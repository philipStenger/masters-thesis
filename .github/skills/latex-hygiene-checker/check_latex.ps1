<#
.SYNOPSIS
    LaTeX Hygiene Checker — checks all thesis .tex files for LaTeX convention violations.
    Based on §6 (LaTeX Best Practices) of the ML Paper Writing Guide.

.USAGE
    Run from the thesis root directory:
        .\.github\skills\latex-hygiene-checker\check_latex.ps1

    Or with an explicit root path:
        .\.github\skills\latex-hygiene-checker\check_latex.ps1 -ThesisRoot "C:\path\to\thesis"

.OUTPUT
    A grouped flag list by check number.
    Each entry: <relative-file-path>:<line>  <line preview>
    A SUMMARY table is printed at the end.

.NOTES
    - Checks 1–3 and 5, 8–10 are single-line pattern matches.
    - Checks 4 (\label before \caption), 6 (equation punctuation), and 7 (blank after equation)
      use multi-line analysis on the full file content.
    - Pure comment lines (^\s*%) are skipped in line-by-line checks.
    - Apply judgement to equation-punctuation false positives in complex multi-line equations.
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

# --- Single-line check helper ---
function Invoke-LineCheck {
    param(
        [string]   $Id,
        [string]   $Name,
        [string]   $Reason,
        [string[]] $Patterns
    )
    Write-Host ("`n--- CHECK {0} : {1} ---" -f $Id, $Name) -ForegroundColor Yellow
    Write-Host ("  Reason: {0}" -f $Reason) -ForegroundColor DarkGray
    $n = 0
    foreach ($f in $tex) {
        $rel   = $f.FullName.Replace($root, '').TrimStart('\/')
        $lines = @(Get-Content $f.FullName -ErrorAction SilentlyContinue)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $l = $lines[$i]
            if ($l -match '^\s*%') { continue }
            $l = $l -replace '(?<!\\)%.*$', ''
            foreach ($p in $Patterns) {
                if ($l -imatch $p) {
                    $v = $l.Trim()
                    if ($v.Length -gt 90) { $v = $v.Substring(0, 90) + '...' }
                    Write-Host ("  {0}:{1}  {2}" -f $rel, ($i + 1), $v)
                    $n++; $script:total++
                    break
                }
            }
        }
    }
    if ($n -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
    $script:counts[$Id] = $n
}

Write-Host ("=" * 68) -ForegroundColor Cyan
Write-Host (" LATEX HYGIENE CHECK  —  {0} files  —  {1}" -f $tex.Count, $root) -ForegroundColor Cyan
Write-Host ("=" * 68) -ForegroundColor Cyan

# CHECK 1a — Parenthetical citation used as grammatical subject
Invoke-LineCheck '1a' 'PARENTHETICAL CITATION AS SUBJECT' `
    'Use \citet{} when the citation is the sentence subject' @(
    '\([A-Z][a-zA-Z\s]+,\s*\d{4}\)\s+(shows?|demonstrates?|finds?|argues?|reports?|states?|notes?|suggests?|proposes?|presents?)',
    '\\(cite|autocite)\{[^}]+\}\s+(shows?|demonstrates?|finds?|argues?|states?|notes?|proposes?|reports?)'
)

# CHECK 1b — Citation without preceding non-breaking space
Invoke-LineCheck '1b' 'CITATION WITHOUT NON-BREAKING SPACE (~)' `
    'Should be word~\cite{key} to prevent line breaks' @(
    '[a-zA-Z0-9\}]\s+\\(cite|autocite|citep)\{'
)

# CHECK 2 — Broken references (??)
Invoke-LineCheck '2' 'BROKEN REFERENCES (??)' `
    'Unresolved \ref{} or \cite{} — must be fixed before submission' @(
    '\?\?'
)

# CHECK 3 — Straight double quotes
Invoke-LineCheck '3' 'STRAIGHT DOUBLE QUOTES IN PROSE' `
    'Use ``text'\'''\'' or \enquote{text} instead of "text"' @(
    '"[^"]{2,60}"'
)

# CHECK 5 — \ref{} instead of \cref{}
Invoke-LineCheck '5' '\ref{} INSTEAD OF \cref{}' `
    'Prefer \cref{} from the cleveref package for intelligent cross-referencing' @(
    '(?<!c)(?<!auto)(?<!name)(?<!page)\\ref\{'
)

# CHECK 8 — Footnote placed before punctuation
Invoke-LineCheck '8' 'FOOTNOTE BEFORE PUNCTUATION' `
    'Footnotes should follow punctuation: word.\footnote{} not word\footnote{.}' @(
    '\\footnote\{[^}]*\}[.,;:]'
)

# CHECK 9 — fullpage package
Invoke-LineCheck '9' 'fullpage PACKAGE (conflicts with electhesis.cls)' `
    'Remove \usepackage{fullpage} — it overrides the thesis style file settings' @(
    '\\usepackage.*\{fullpage\}'
)

# CHECK 10 — Manual line breaks in prose
Invoke-LineCheck '10' 'FORCED LINE BREAKS (\\) IN PROSE' `
    'May create orphaned single-word lines — verify in compiled PDF' @(
    '[^\\]\\\\[ \t]*$'
)

# --- Multi-line checks ---

# CHECK 4 — \label{} before \caption{} in figure/table environments
Write-Host "`n--- CHECK 4 : \label{} BEFORE \caption{} ---" -ForegroundColor Yellow
Write-Host "  Reason: \label must follow \caption — reverse order breaks hyperref links" -ForegroundColor DarkGray
$n4 = 0
foreach ($f in $tex) {
    $rel     = $f.FullName.Replace($root, '').TrimStart('\/')
    $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    $envPat = '(?s)\\begin\{(figure|table|subfigure)(\*)?\}(.*?)\\end\{(figure|table|subfigure)(\*)?\}'
    foreach ($m in [regex]::Matches($content, $envPat)) {
        $body       = $m.Groups[3].Value
        $labelIdx   = $body.IndexOf('\label{')
        $captionIdx = $body.IndexOf('\caption{')
        if ($labelIdx -ge 0 -and $captionIdx -ge 0 -and $labelIdx -lt $captionIdx) {
            $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
            Write-Host ("  {0}:~{1}  \label before \caption in \begin{{{2}}}" -f $rel, $lineNum, $m.Groups[1].Value)
            $n4++; $script:total++
        }
    }
}
if ($n4 -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
$script:counts['4'] = $n4

# CHECK 6 — Display equation missing terminal punctuation
Write-Host "`n--- CHECK 6 : EQUATION MISSING TERMINAL PUNCTUATION ---" -ForegroundColor Yellow
Write-Host "  Reason: Display equations are part of the sentence and require , or . at the end" -ForegroundColor DarkGray
$n6 = 0
foreach ($f in $tex) {
    $rel     = $f.FullName.Replace($root, '').TrimStart('\/')
    $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    $eqPat = '(?s)\\begin\{(equation|align|gather|multline|eqnarray)(\*)?\}(.*?)\\end\{(equation|align|gather|multline|eqnarray)(\*)?\}'
    foreach ($m in [regex]::Matches($content, $eqPat)) {
        $body = $m.Groups[3].Value
        # Strip trailing \label{...} which legally follows the equation content
        $body = ($body -replace '\\label\{[^}]+\}\s*$', '').TrimEnd()
        if ($body -notmatch '[,\.][\\s\s]*$') {
            $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
            $preview = ($m.Groups[3].Value.Trim() -split "`n")[0]
            if ($preview.Length -gt 60) { $preview = $preview.Substring(0, 60) + '...' }
            Write-Host ("  {0}:~{1}  [{2}] {3}" -f $rel, $lineNum, $m.Groups[1].Value, $preview)
            $n6++; $script:total++
        }
    }
}
if ($n6 -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
$script:counts['6'] = $n6

# CHECK 7 — Blank line immediately after \end{equation} (creates paragraph break)
Write-Host "`n--- CHECK 7 : BLANK LINE AFTER EQUATION ---" -ForegroundColor Yellow
Write-Host "  Reason: A blank line after \end{equation} creates an unintended paragraph break" -ForegroundColor DarkGray
$n7 = 0
foreach ($f in $tex) {
    $rel   = $f.FullName.Replace($root, '').TrimStart('\/')
    $lines = @(Get-Content $f.FullName -ErrorAction SilentlyContinue)
    for ($i = 0; $i -lt $lines.Count - 1; $i++) {
        $curr = $lines[$i].Trim()
        $next = $lines[$i + 1].Trim()
        if ($curr -match '\\end\{(equation|align|gather|multline|eqnarray)(\*)?\}' -and $next -eq '') {
            Write-Host ("  {0}:{1}  Blank line after \end{{{2}}}" -f $rel, ($i + 1), $Matches[1])
            $n7++; $script:total++
        }
    }
}
if ($n7 -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
$script:counts['7'] = $n7

# --- Summary ---
Write-Host ("`n" + "=" * 68) -ForegroundColor Cyan
Write-Host " SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 68) -ForegroundColor Cyan
foreach ($kv in $script:counts.GetEnumerator()) {
    $c = if ($kv.Value -gt 0) { 'Yellow' } else { 'DarkGreen' }
    Write-Host ("  Check {0,-3}: {1,4} flag(s)" -f $kv.Key, $kv.Value) -ForegroundColor $c
}
Write-Host ("  TOTAL   : {0,4} flag(s)" -f $script:total) -ForegroundColor Cyan
Write-Host "`nNOTE: Checks 4, 6, 7 use heuristics on raw file content — verify edge cases." -ForegroundColor DarkGray
