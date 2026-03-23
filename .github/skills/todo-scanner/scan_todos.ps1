<#
.SYNOPSIS
    Thesis TODO Scanner — finds all TODO, FIXME, and actionable comments in .tex files.

.USAGE
    Run from the thesis root directory:
        .\.github\skills\todo-scanner\scan_todos.ps1

    Or with an explicit root path:
        .\.github\skills\todo-scanner\scan_todos.ps1 -ThesisRoot "C:\path\to\thesis"

.OUTPUT
    A categorised list of TODO items grouped by type, with file paths and line numbers.
    Followed by a SUMMARY table.

.NOTES
    Categories scanned:
      A — Explicit TODO / FIXME / HACK / XXX / TBD / WIP comments
      B — Placeholder citation keys (\cite{TODO-...})
      C — Inline TODO placeholders in body text (\textit{TODO}, \textbf{TODO}, etc.)
      D — Review requests (% ... review ...)
      E — Missing content markers (% ... add / insert / missing / incomplete / stub / placeholder / needs ...)
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

# ── Storage ──────────────────────────────────────────────────────────────
$script:results = [ordered]@{}   # category → list of PSObjects
$script:counts  = [ordered]@{}
$script:total   = 0

function Add-Finding {
    param(
        [string]$Category,
        [string]$File,
        [int]$Line,
        [string]$Text,
        [string]$RawLine
    )
    if (-not $script:results.Contains($Category)) {
        $script:results[$Category] = [System.Collections.Generic.List[PSObject]]::new()
    }
    $script:results[$Category].Add([PSCustomObject]@{
        File    = $File
        Line    = $Line
        Text    = $Text
        RawLine = $RawLine
    })
}

# Dedup tracker: "file:line:category" → $true
$seen = @{}

function Invoke-Scan {
    param(
        [string]   $Id,
        [string]   $Name,
        [string[]] $Patterns,
        [switch]   $CommentOnly,    # only match inside LaTeX comments (% ...)
        [switch]   $BodyOnly         # only match in non-comment body text
    )
    Write-Host ("`n--- CATEGORY {0}: {1} ---" -f $Id, $Name) -ForegroundColor Yellow
    $n = 0
    foreach ($f in $tex) {
        $rel   = $f.FullName.Replace($root, '').TrimStart('\/')
        $lines = @(Get-Content $f.FullName -ErrorAction SilentlyContinue)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $raw = $lines[$i]

            if ($CommentOnly) {
                # Extract only the comment portion
                if ($raw -match '^\s*%(.*)$') {
                    $target = $Matches[1]
                } elseif ($raw -match '(?<!\\)%(.*)$') {
                    $target = $Matches[1]
                } else {
                    continue
                }
            } elseif ($BodyOnly) {
                # Strip comments, keep body
                $target = $raw -replace '(?<!\\)%.*$', ''
                if ($target -match '^\s*$') { continue }
            } else {
                $target = $raw
            }

            foreach ($p in $Patterns) {
                if ($target -imatch $p) {
                    $key = "${rel}:$($i+1):${Id}"
                    if ($seen.ContainsKey($key)) { continue }
                    $seen[$key] = $true

                    # Build a concise description from the matched line
                    $desc = $raw.Trim()
                    if ($desc.Length -gt 120) { $desc = $desc.Substring(0, 120) + '...' }

                    Write-Host ("  {0}:{1}  {2}" -f $rel, ($i + 1), $desc)
                    Add-Finding -Category "${Id}: ${Name}" -File $rel -Line ($i + 1) -Text $desc -RawLine $raw
                    $n++
                    $script:total++
                    break   # one flag per line per category
                }
            }
        }
    }
    if ($n -eq 0) { Write-Host "  (no matches)" -ForegroundColor DarkGreen }
    $script:counts[$Id] = $n
}

# ══════════════════════════════════════════════════════════════════════════
Write-Host ("=" * 72) -ForegroundColor Cyan
Write-Host (" THESIS TODO SCAN  —  {0} files  —  {1}" -f $tex.Count, $root) -ForegroundColor Cyan
Write-Host ("=" * 72) -ForegroundColor Cyan

# ── Category A: Explicit TODO / FIXME / HACK / XXX / TBD / WIP ─────────
Invoke-Scan 'A' 'EXPLICIT TODO / FIXME / HACK / XXX / TBD / WIP' @(
    '%\s*TODO\b',
    '%\s*FIXME\b',
    '%\s*HACK\b',
    '%\s*XXX\b',
    '%\s*TBD\b',
    '%\s*WIP\b',
    '\bTODO\b',
    '\bFIXME\b'
)

# ── Category B: Placeholder citation keys (\cite{TODO-...}) ────────────
Invoke-Scan 'B' 'PLACEHOLDER CITATION KEYS' @(
    '\\cite\{TODO',
    '\\autocite\{TODO',
    '\\citet\{TODO',
    '\\citep\{TODO'
) -BodyOnly

# ── Category C: Inline TODO placeholders in body text ───────────────────
Invoke-Scan 'C' 'INLINE TODO PLACEHOLDERS IN BODY TEXT' @(
    '\\textit\{TODO\}',
    '\\textbf\{TODO\}',
    '\\emph\{TODO\}',
    '\bTODO\b'
) -BodyOnly

# ── Category D: Review request comments ─────────────────────────────────
Invoke-Scan 'D' 'REVIEW REQUESTS IN COMMENTS' @(
    '\breview\b',
    '\bverify\b',
    '\bcheck\b',
    '\bconfirm\b'
) -CommentOnly

# ── Category E: Missing-content markers ─────────────────────────────────
Invoke-Scan 'E' 'MISSING CONTENT MARKERS' @(
    '\badd\b',
    '\binsert\b',
    '\bmissing\b',
    '\bincomplete\b',
    '\bstub\b',
    '\bplaceholder\b',
    '\bneeds?\b',
    '\bdescribe\b',
    '\bclarify\b',
    '\bstate\b',
    '\bupdate\b'
) -CommentOnly

# ══════════════════════════════════════════════════════════════════════════
Write-Host ("`n" + "=" * 72) -ForegroundColor Cyan
Write-Host " SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 72) -ForegroundColor Cyan
foreach ($kv in $script:counts.GetEnumerator()) {
    $c = if ($kv.Value -gt 0) { 'Yellow' } else { 'DarkGreen' }
    Write-Host ("  Category {0,-3}: {1,4} item(s)" -f $kv.Key, $kv.Value) -ForegroundColor $c
}
Write-Host ("  TOTAL      : {0,4} item(s)" -f $script:total) -ForegroundColor Cyan

# ── JSON output for machine consumption ──────────────────────────────────
$jsonOut = $script:results.GetEnumerator() | ForEach-Object {
    [PSCustomObject]@{
        category = $_.Key
        items    = @($_.Value | ForEach-Object {
            [PSCustomObject]@{
                file    = $_.File
                line    = $_.Line
                text    = $_.Text
                rawLine = $_.RawLine
            }
        })
    }
}

$jsonPath = Join-Path $root ".github\skills\todo-scanner\last_scan.json"
$jsonOut | ConvertTo-Json -Depth 5 | Set-Content -Path $jsonPath -Encoding UTF8
Write-Host ("`nJSON results written to: {0}" -f $jsonPath) -ForegroundColor DarkGray
