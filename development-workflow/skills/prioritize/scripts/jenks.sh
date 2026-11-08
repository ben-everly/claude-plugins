#!/usr/bin/env bash
# Jenks natural-breaks tiers over log(score).
# Usage: bash jenks.sh K < input
#   input:  lines "id<TAB>wsjf"
#   output: lines "id<TAB>tier", score descending, tier 1 = highest
# Exits 2 with a message on stderr for bad input.

K=$1
case $K in
'' | *[!0-9]* | 0*)
  echo "jenks.sh: K must be a positive integer" >&2
  exit 2
  ;;
esac

exec awk -v K="$K" '
BEGIN { FS = "\t"; n = 0 }
function fail(msg) {
  print "jenks.sh: line " NR ": " msg > "/dev/stderr"
  failed = 1
  exit 2
}
{
  sub(/\r$/, "")
  if (NF != 2) fail("expected 2 tab-separated fields")
  if ($2 !~ /^[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$/) fail("non-numeric score")
  if ($2 + 0 <= 0) fail("score must be > 0")
  n++
  id[n] = $1
  sc[n] = $2 + 0
}
function cost(i, j,   w, s) {
  w = W[j] - W[i - 1]
  s = S[j] - S[i - 1]
  return (Q[j] - Q[i - 1]) - s * s / w
}
END {
  if (failed || n == 0) exit failed ? 2 : 0

  # stable insertion sort of item indices by score descending
  for (i = 1; i <= n; i++) {
    ord[i] = i
    for (j = i; j > 1 && sc[ord[j - 1]] < sc[ord[j]]; j--) {
      t = ord[j]; ord[j] = ord[j - 1]; ord[j - 1] = t
    }
  }

  # distinct scores (descending) with counts and prefix sums of log
  m = 0
  for (i = 1; i <= n; i++) {
    if (i == 1 || sc[ord[i]] != sc[ord[i - 1]]) m++
    dix[i] = m
    cnt[m]++
    x[m] = log(sc[ord[i]])
  }
  for (i = 1; i <= m; i++) {
    W[i] = W[i - 1] + cnt[i]
    S[i] = S[i - 1] + cnt[i] * x[i]
    Q[i] = Q[i - 1] + cnt[i] * x[i] * x[i]
  }

  ke = (K < m) ? K : m

  # F[c,i]: min cost splitting distinct i..m into c groups; first group i..cut-1
  for (i = 1; i <= m; i++) F[1, i] = cost(i, m)
  for (c = 2; c <= ke; c++) {
    for (i = 1; i <= m - c + 1; i++) {
      best = -1
      for (t = i + 1; t <= m - c + 2; t++) {
        v = cost(i, t - 1) + F[c - 1, t]
        # ascending t, replace only when clearly better: ties keep the
        # smaller (nearer-the-top) first tier. Costs come from differences
        # of float prefix sums, so mathematically equal splits can differ in
        # the last few digits; 1e-9 relative absorbs that rounding without
        # merging splits that genuinely differ.
        if (best < 0 || v < best - (best * 1e-9 + 1e-12)) { best = v; bt = t }
      }
      F[c, i] = best
      C[c, i] = bt
    }
  }

  # reconstruct: tier of each distinct value
  i = 1
  for (c = ke; c >= 1; c--) {
    e = (c == 1) ? m : C[c, i] - 1
    for (j = i; j <= e; j++) tier[j] = ke - c + 1
    i = e + 1
  }

  for (i = 1; i <= n; i++) print id[ord[i]] "\t" tier[dix[i]]
}
' 
