<#
.SYNOPSIS
    Writing Style Scanner — checks all thesis .tex files for style violations.
    Based on §5 (Writing Style and Clarity) of the ML Paper Writing Guide.

.USAGE
    Run from the thesis root directory:
        .\.github\skills\writing-style-scanner\scan_style.ps1

    Or with an explicit root path:
        .\.github\skills\writing-style-scanner\scan_style.ps1 -ThesisRoot "C:\path\to\thesis"

.OUTPUT
    A grouped flag list by check category.
    Each entry: <relative-file-path>:<line>  <line preview>
    A SUMMARY table is printed at the end.

.NOTES
    - Pure comment lines (^\s*%) are skipped.
    - Inline comments are stripped before pattern matching.
    - Math environments are NOT excluded — verify math-mode lines manually before filing issues.
    - All matching is case-insensitive unless noted.
#>
param(
    [string]$ThesisRoot = $PWD.Path
)

$root = (Resolve-Path $ThesisRoot).Path

$tex = @(
    Get-ChildItem -Path $root -Recurse -Filter "*.tex" |
    Where-Object { $_.Name -notmatch '\.(cls|sty|bst)$' -and $_.FullName -notmatch '\\\.git\\' } |
    Sort-Object FullName
)

if ($tex.Count -eq 0) { Write-Error "No .tex files found under: $root"; exit 1 }

$script:counts = [ordered]@{}
$script:total  = 0

function Invoke-Check {
    param(
        [string]   $Id,
        [string]   $Name,
        [string[]] $Patterns
    )
    Write-Host ("`n--- CHECK {0} : {1} ---" -f $Id, $Name) -ForegroundColor Yellow
    $n = 0
    foreach ($f in $tex) {
        $rel   = $f.FullName.Replace($root, '').TrimStart('\/')
        $lines = @(Get-Content $f.FullName -ErrorAction SilentlyContinue)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $l = $lines[$i]
            if ($l -match '^\s*%') { continue }             # skip pure comment lines
            $l = $l -replace '(?<!\\)%.*$', ''              # strip inline comments
            foreach ($p in $Patterns) {
                if ($l -imatch $p) {
                    $v = $l.Trim()
                    if ($v.Length -gt 90) { $v = $v.Substring(0, 90) + '...' }
                    Write-Host ("  {0}:{1}  {2}" -f $rel, ($i + 1), $v)
                    $n++
                    $script:total++
                    break   # one flag per line per check group
                }
            }
        }
    }
    if ($n -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
    $script:counts[$Id] = $n
}

Write-Host ("=" * 68) -ForegroundColor Cyan
Write-Host (" WRITING STYLE SCAN  —  {0} files  —  {1}" -f $tex.Count, $root) -ForegroundColor Cyan
Write-Host ("=" * 68) -ForegroundColor Cyan

Invoke-Check 'A' 'BANNED WORDS (remove entirely)' @(
    '\bactually\b', '\ba bit\b', '\bfortunately\b',
    '\bto our knowledge\b', '\bnote that\b', '\bobserve that\b', '\btry to\b',
    '\bvery\b', '\breally\b', '\bextremely\b',
    '\bhowever\b', '\bfurthermore\b', '\badditionally\b',
    '\bin addition\b', '\bmoreover\b', '\bnevertheless\b'
)

Invoke-Check 'B' 'CONTRACTIONS AND REPLACEABLE WORDS' @(
    "it's", "don't", "can't", "won't", "isn't", "aren't",
    "wasn't", "weren't", "doesn't", "didn't", "we've", "we're",
    "we'd", "they're", "that's", "there's",
    '\bwant\b', '\bhope\b'
)

Invoke-Check 'C' 'PASSIVE VOICE' @(
    '\b(is|are|was|were|be|been|being)\s+(shown|presented|used|performed|conducted|described|observed|found|demonstrated|evaluated|compared|achieved|obtained|computed|estimated|applied|proposed|introduced|defined|given|measured|tested|validated|reported|discussed|employed|utilised)\b',
    '\bhas been\b', '\bhave been\b', '\bhad been\b'
)

Invoke-Check 'D' 'VAGUE LANGUAGE (replace with a specific metric or claim)' @(
    '\bperformance\b', '\beffective\b', '\bsignificantly\b', '\bdramatically\b',
    '\bgroundbreaking\b', '\bbreakthrough\b', '\bstate-of-the-art\b',
    '\brobust\b', '\baccurate\b', '\bsuperior\b'
)

Invoke-Check 'E' 'BARE COMPARATIVES (missing explicit referent)' @(
    '\bbetter\b(?!\s+than)', '\bfaster\b(?!\s+than)',
    '\bhigher\b(?!\s+than)', '\blower\b(?!\s+than)',
    '\bimproved\b(?!\s+(over|compared|relative|versus|vs\b))'
)

Invoke-Check 'F' 'ANTHROPOMORPHISMS OF ALGORITHMS' @(
    '\b(model|network|algorithm|system|method|approach)\s+(knows|understands|believes|thinks|assumes|decides|chooses|sees|perceives|feels|wants|tries|learns)\b'
)

Invoke-Check 'G' 'STANDALONE DEMONSTRATIVES (should be adjectives: "this result", not "this")' @(
    '\bthis\s+(is|was|has|have|shows|demonstrates|suggests|means|allows|enables|results|implies)\b',
    '\bthese\s+(are|were|have|show|demonstrate|suggest|allow|enable)\b'
)

Invoke-Check 'H' "APOSTROPHE POSSESSIVES (rephrase as 'the Y of X')" @(
    "[A-Z][a-zA-Z]+'s"
)

Invoke-Check 'I' 'EXCESSIVE HEDGING in declarative claims (may / might / could be)' @(
    '\bmay\b', '\bmight\b', '\bcould be\b'
)

Invoke-Check 'J' 'IMPRECISE WORDS HIDDEN IN LaTeX QUOTES' @(
    "``[^'` ][^'`]{1,40}''"
)

Invoke-Check 'K' "UNPAIRED 'ON THE OTHER HAND' (must be paired with 'on the one hand')" @(
    '\bon the other hand\b'
)

Write-Host ("`n" + "=" * 68) -ForegroundColor Cyan
Write-Host " SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 68) -ForegroundColor Cyan
foreach ($kv in $script:counts.GetEnumerator()) {
    $c = if ($kv.Value -gt 0) { 'Yellow' } else { 'DarkGreen' }
    Write-Host ("  Check {0,-3}: {1,4} flag(s)" -f $kv.Key, $kv.Value) -ForegroundColor $c
}
Write-Host ("  TOTAL   : {0,4} flag(s)" -f $script:total) -ForegroundColor Cyan
Write-Host "`nNOTE: Verify math-environment lines and figure captions for false positives." -ForegroundColor DarkGray
