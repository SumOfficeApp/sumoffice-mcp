# Installing the SumOffice MCP server (instructions for AI agents such as Cline)

SumOffice MCP gives you real Word and Excel files: open a .docx/.xlsx/.xlsm, read it, propose an edit, apply it after the user approves, and download an intact copy. There is nothing to build or clone. No account and no API key are needed.

## Option A (recommended): remote server, nothing to install

Add this to the MCP settings file (for Cline: `cline_mcp_settings.json`):

```json
{
  "mcpServers": {
    "sumoffice": {
      "type": "streamableHttp",
      "url": "https://view.sumoffice.com/mcp",
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

If the client cannot connect to remote HTTP servers, use the bridge instead (needs Node.js 18+):

```json
{
  "mcpServers": {
    "sumoffice": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://view.sumoffice.com/mcp"]
    }
  }
}
```

With the remote server, pass files to `document_open_file` as a public `url` or as `base64` + `name` (up to 50 MB).

## Option B: local stdio server in Docker (to open files by local path)

Requires Docker. Ask the user which folder the agent may read, then mount it at `/work`:

```json
{
  "mcpServers": {
    "sumoffice": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "/ABSOLUTE/PATH/TO/FILES:/work", "hissih/sumoffice-mcp:0.3.1"]
    }
  }
}
```

Replace `/ABSOLUTE/PATH/TO/FILES` with the absolute path the user gives you. Then call `document_open_file` with `path: "/work/<file name>"`.

## Check that it works

1. Call `document_open` with `slug: "offer"` (a demo document; `slug: "cashflow"` is a demo workbook) — no user file needed.
2. Call `document_describe`, then `document_read` with `from: 0, count: 5`.
3. If you get paragraph text back, the server is installed.

## Rules for using it

- `*_propose_*` never changes anything; show the returned diff to the user and call `*_apply` only after they agree.
- `document_save_copy` returns a 24-hour download link to the edited copy; the original file is never overwritten.
- Macros are read and planned, never executed by the server.

Privacy: files are opened in a private session on SumOffice servers (Frankfurt) and deleted after the session or 24 hours at most — https://sumoffice.com/app-privacy.html. Support: hello@sumoffice.com
