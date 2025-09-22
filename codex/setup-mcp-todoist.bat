@echo off
echo Setting up Todoist MCP Server...
echo.

cd /d "%~dp0"

echo Installing dependencies...
call npm init -y >nul 2>&1
call npm install @chrusic/todoist-mcp-server-extended

echo.
echo Setup complete! Now configure your client:
echo.
echo For Codex:
echo   Edit: %USERPROFILE%\.codex\config.toml
echo   Add the configuration from MCP_SETUP_GUIDE.md
echo.
echo For Claude Code:
echo   Run: claude mcp add todoist-extended --env TODOIST_API_TOKEN=c9f774b30f4dbb207dee2ce8fed427efaf574d19 -- node "%~dp0node_modules\@chrusic\todoist-mcp-server-extended\dist\index.js"
echo.
pause