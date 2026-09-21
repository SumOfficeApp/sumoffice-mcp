# SumOffice MCP server — real Word and Excel for agents

One server, two ways to run it. The agent opens **your** `.docx` / `.xlsx` / `.xlsm`, reads it, proposes a change, you approve, the file comes back intact — Excel and Word open the result without a repair dialog. Macros (VBA) and Power Query travel with the file.

Registry name: `com.sumoffice/office` · page with proof: https://sumoffice.com/mcp · image: `docker.io/hissih/sumoffice-mcp`

## Remote — nothing to install

`https://view.sumoffice.com/mcp` (streamable HTTP).

```sh
claude mcp add --transport http sumoffice https://view.sumoffice.com/mcp
```

Clients without HTTP support: `npx -y mcp-remote https://view.sumoffice.com/mcp` (see `examples/`).

## Local over stdio — local file paths

```sh
docker run -i --rm -v "$PWD:/work" hissih/sumoffice-mcp
```

The server runs on your machine and accepts `path` in `document_open_file` (paths under `/work`). The file itself is opened in a private, short-lived editor session on the SumOffice server and deleted after the session; nothing in the file is executed.

## Tools

| Documents (.docx) | Spreadsheets (.xlsx/.xlsm/.xlsb) | Both |
|---|---|---|
| `document_open_file`, `document_open`, `document_describe`, `document_read`, `document_find`, `document_comments`, `document_propose_replacement` → `document_apply` | `sheet_describe`, `sheet_read`, `sheet_find`, `sheet_propose_edits` → `sheet_apply`, `macro_list`, `macro_read_source`, `macro_plan`, `query_list`, `query_explain`, `workbook_inspect` | `document_save_copy`, `document_export_pdf` |

`propose_*` never writes: it returns a diff for the person or the client to approve; `*_apply` applies exactly that proposal. Every step is listed in the response, so the agent cannot change a file silently.

## Examples

- `examples/claude-desktop.json` — Claude Desktop (`claude_desktop_config.json`), local stdio via Docker.
- `examples/cursor-mcp.json` — Cursor (`.cursor/mcp.json`), remote HTTP.
- `examples/claude-code.sh` — Claude Code, both variants.
- `examples/docker-compose.yml` — the local server as a compose service with a mounted folder.

## What it does not do yet

- One editor session per document at a time; a second agent on the same file gets read-only.
- Power Query definitions are preserved, not refreshed, in the server session.
- Macros are read and routed (which will run natively, which stay in Excel); they are not executed by the MCP server.

## Limits and privacy

Free, no account. Remote: per-address daily quota; files are deleted after the session or 24 hours at most, never used for anything else. Details: https://sumoffice.com/app-privacy.html

## Licence

This repository (documentation, manifest, examples) is MIT. The server image is free for evaluation and for use with the public endpoint; production use inside an organisation is licensed per application — https://sumoffice.com/download#server. Questions: hello@sumoffice.com
