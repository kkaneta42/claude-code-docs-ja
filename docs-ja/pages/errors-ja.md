> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エラーリファレンス

> Claude Code のランタイムエラーメッセージを検索し、各エラーの意味と修正方法を確認できます。

このページでは、Claude Code が表示するランタイムエラーと各エラーからの復旧方法、および応答がエラーなしで問題があるように見える場合に確認すべき内容を一覧表示しています。セットアップ中の `command not found` や TLS エラーなどのインストールエラーについては、[インストールとログインのトラブルシューティング](/docs/ja/troubleshoot-install)を参照してください。

[ラッパーと IDE エラー](#wrapper-and-ide-errors)は Claude Code 自体ではなく起動元のプログラムが出力するものですが、これを除き、これらのエラーと復旧コマンドは CLI、[Desktop アプリ](/docs/ja/desktop)、および[クラウドセッション](/docs/ja/claude-code-on-the-web)全体に適用されます。これら 3 つはすべて同じ Claude Code CLI をラップしているためです。その他のサーフェス固有の問題については、そのサーフェスのページのトラブルシューティングセクションを参照してください。

<Note>
  Claude Code は Claude API を呼び出してモデルレスポンスを取得するため、ほとんどのランタイムエラーは基盤となる API エラーコードにマップされます。このページでは、Claude Code 内での各エラーの意味と復旧方法について説明しています。生の HTTP ステータスコード定義については、[Claude Platform エラーリファレンス](https://platform.claude.com/docs/en/api/errors)を参照してください。
</Note>

<h2 id="find-your-error">
  エラーを見つける
</h2>

以下のセクションに表示されるメッセージを照合してください。

| メッセージ | セクション |
| :- | :- |
| `API Error: 500 Internal server error` | [サーバーエラー](#api-error-500-internal-server-error) |
| `API Error: Repeated 529 Overloaded errors` | [サーバーエラー](#api-error-repeated-529-overloaded-errors) |
| `Opus is experiencing high load` / `Fable is experiencing high load` | [サーバーエラー](#api-error-repeated-529-overloaded-errors) |
| `Request timed out` | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は [ネットワーク](#unable-to-connect-to-api) |
| `API Error: No response from API` | [サーバーエラー](#no-response-from-api) |
| `Server error mid-response. The response above may be incomplete.` | [サーバーエラー](#the-response-above-may-be-incomplete) |
| `Connection lost mid-response` / `Your computer went to sleep mid-response` / `The response stopped arriving` | [サーバーエラー](#the-response-above-may-be-incomplete) |
| `Connection closed mid-response` / `Response stalled mid-stream` | [サーバーエラー](#the-response-above-may-be-incomplete) |
| `Part of the response never arrived` / `The response stream was malformed` | [サーバーエラー](#the-response-above-may-be-incomplete) |
| `API Error: Content block not found` / `API Error: Content block already closed` / `API Error: Stream event unreadable` | [サーバーエラー](#the-response-above-may-be-incomplete) |
| `Connection lost before a response was produced` / `Your computer went to sleep before a response was produced` / `The response stalled before a response was produced` | [自動再試行](#automatic-retries) |
| `Connection closed while thinking` / `Response stalled while thinking` | [自動再試行](#automatic-retries) |
| `Connection lost while your computer was asleep` | [自動再試行](#automatic-retries) |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Auto mode could not evaluate this action and is blocking it for safety` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Auto mode classifier transcript exceeded context window` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `Agent aborted: auto mode classifier request refused by the safety safeguard` | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action) |
| `The server-side auto mode classifier gave no verdict` | [サーバーエラー](#the-server-returned-no-safety-verdict) |
| `Auto mode is unavailable — the server returned no safety verdict for the last 10 responses` | [サーバーエラー](#the-server-returned-no-safety-verdict) |
| `Agent terminated early due to an API error` | [サーバーエラー](#agent-terminated-early-due-to-an-api-error) |
| `You've hit your session limit` / `You've hit your weekly limit` / `You've hit your Opus limit` / `You've hit your Sonnet limit` | [使用制限](#youve-hit-your-session-limit) |
| `Usage credits required for 1M context` | [使用制限](#usage-credits-required-for-1m-context) |
| `the prompt to confirm went unanswered — nothing was sent` | [使用制限](#the-prompt-to-confirm-went-unanswered) |
| `Server is temporarily limiting requests` | [使用制限](#server-is-temporarily-limiting-requests) |
| `Request rejected (429)` | [使用制限](#request-rejected-429) |
| `Credit balance is too low` | [使用制限](#credit-balance-is-too-low) |
| `You've hit your monthly spend limit` / `You've hit your individual spend limit` / `You've hit your org's monthly spend limit` / `You've hit your channel's monthly spend limit` / `You've hit your team's shared budget` / `You've hit your individual usage limit` | [使用制限](#youve-hit-your-monthly-spend-limit) |
| `Could not update your spend limit` | [使用制限](#could-not-update-your-spend-limit) |
| `spend limit reached` / `spend limit unavailable` | [使用制限](#spend-limit-reached) |
| `Not logged in · Please run /login` | [認証](#not-logged-in) |
| `Couldn't save your login` | [認証](#couldnt-save-your-login) |
| `Authentication required · Sign in again to continue` | [認証](#not-logged-in) |
| `Could not resolve authentication method` | [認証](#could-not-resolve-authentication-method) |
| `Invalid API key` | [認証](#invalid-api-key) |
| `Your apiKeyHelper script is failing` | [認証](#your-apikeyhelper-script-is-failing) |
| `Invalid auth token · Fix external auth token` | [認証](#invalid-request-header-value) |
| `Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable` | [認証](#invalid-request-header-value) |
| `Invalid request header from the environment · Fix the environment variable` | [認証](#invalid-request-header-value) |
| `This organization has been disabled` | [認証](#this-organization-has-been-disabled) |
| `Your organization has disabled API key authentication` | [認証](#your-organization-has-disabled-api-key-authentication) |
| `Your organization has disabled Claude subscription access` | [認証](#your-organization-has-disabled-claude-subscription-access) |
| `Routines are disabled by your organization's policy` | [認証](#routines-are-disabled-by-your-organizations-policy) |
| `Remote Control is only available when using Claude via api.anthropic.com` | [認証](#remote-control-requires-the-anthropic-api) |
| `OAuth token refresh failed — run /login to re-authenticate` | [認証](#remote-control-couldnt-refresh-your-login) |
| `JWT refresh failed: no OAuth token — run /login` | [認証](#remote-control-couldnt-refresh-your-login) |
| `Claude.ai login expired` | [認証](#remote-control-couldnt-refresh-your-login) |
| `Claude.ai login was rejected — run /login, then /remote-control` | [認証](#remote-control-couldnt-refresh-your-login) |
| `OAuth token unavailable — run /login to restore Remote Control` | [認証](#remote-control-couldnt-refresh-your-login) |
| `Signed out of Claude — run /login, then /remote-control` | [認証](#remote-control-couldnt-refresh-your-login) |
| `signed-in claude.ai account or organization changed on this machine` | [認証](#remote-control-stopped-because-the-signed-in-account-changed) |
| `Remote Control stopped — the app running this session is now signed in to a different Claude account` | [認証](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `Remote Control stopped — the app running this session is signed out of Claude` | [認証](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `Couldn't verify your organization's policy for remote control` | [Remote Control のトラブルシューティング](/docs/ja/remote-control#couldnt-verify-your-organizations-policy-for-remote-control) |
| `Remote Control is disabled by your organization's policy` | [Remote Control のトラブルシューティング](/docs/ja/remote-control#remote-control-is-disabled-by-your-organizations-policy) |
| `Remote Control was turned off by your organization's policy` | [Remote Control のトラブルシューティング](/docs/ja/remote-control#remote-control-was-turned-off-by-your-organizations-policy) |
| `OAuth token revoked` / `OAuth token has expired` | [認証](#oauth-token-revoked-or-expired) |
| `Failed to authenticate: OAuth token revoked` | [認証](#oauth-token-revoked-or-expired) |
| `Your account does not have access to Claude. Please login again or contact your administrator.` | [認証](#oauth-token-revoked-or-expired) |
| `API Error: 401 Invalid authentication credentials` | [認証](#api-error-401-invalid-authentication-credentials) |
| `Login expired · Please run /login` | [認証](#login-expired) |
| `Failed to start OAuth callback server` | [認証](#failed-to-start-oauth-callback-server) |
| `Claude login not accepted · Run /login, then try again` | [認証](#claude-login-not-accepted) |
| `Artifacts need a claude.ai login` | [認証](#artifacts-need-a-claude-ai-login) |
| `Not signed in to the Cloud gateway — run /login.` | [認証](#administrator-policy-requires-a-cloud-gateway-sign-in) |
| `Administrator policy requires a Cloud gateway sign-in on this machine` | [認証](#administrator-policy-requires-a-cloud-gateway-sign-in) |
| `Failed to authenticate: OAuth session expired and could not be refreshed` | [認証](#login-expired) |
| `Could not refresh your login because another Claude Code process is refreshing it` | [認証](#could-not-refresh-your-login) |
| `Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh` | [認証](#could-not-refresh-your-login) |
| `Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted` | [認証](#your-account-is-on-hold) |
| `Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted` | [認証](#your-account-is-on-hold) |
| `Anthropic profile login expired · Re-authenticate your Anthropic profile` | [認証](#anthropic-profile-login-expired) |
| `Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile` | [認証](#anthropic-profile-login-expired) |
| `does not meet scope requirement user:profile` | [認証](#oauth-scope-requirement) |
| `claude.ai rejected the session token` / `session token rejected` | [認証](#claude-ai-rejected-the-session-token) |
| `MCP server "<name>" needs you to sign in again (run /mcp to re-authenticate)` | [認証](#mcp-server-needs-you-to-sign-in-again) |
| `rejected the credential from its headersHelper` / `rejected the Authorization header in its config` | [認証](#mcp-server-needs-you-to-sign-in-again) |
| `MCP server "<name>" needs additional permissions (scope: "<scope>") — run /mcp to re-authenticate` | [認証](#mcp-server-needs-you-to-sign-in-again) |
| `MCP server "<name>" requires re-authorization (token expired)` | [認証](#mcp-server-needs-you-to-sign-in-again) |
| `This server's URL is missing or not a valid URL, so sign-in can't start` | [認証](#mcp-server-url-is-missing-or-not-a-valid-url) |
| `Issuer mismatch in authorization response (RFC 9207)` | [認証](#issuer-mismatch-in-authorization-response) |
| `Refusing to send credentials to non-https token endpoint` / `<short-name> from the MCP SDK for <server-url>` | [認証](#refusing-to-send-credentials-to-non-https-token-endpoint) |
| `Cloud gateway session expired — run /login to reconnect.` | [認証](#cloud-gateway-session-expired) |
| `Cloud gateway <url> no longer accepts this session` | [認証](#cloud-gateway-session-expired) |
| `Sign-in timed out while waiting for you to continue. Try again.` | [認証](#sign-in-timed-out-while-waiting-for-you-to-continue) |
| `AWS credentials expired or invalid` | [認証](#aws-credentials-expired-or-invalid) |
| `AWS authentication failed` | [認証](#aws-authentication-failed) |
| `Google Cloud credentials expired or invalid` | [認証](#google-cloud-credentials-expired-or-invalid) |
| `Google Cloud authentication failed` | [認証](#google-cloud-authentication-failed) |
| `Microsoft Foundry authentication failed` | [認証](#microsoft-foundry-authentication-failed) |
| `Gateway refused the request` | [認証](#gateway-refused-the-request) |
| `Could not load AWS credentials` / `Could not load Google Cloud credentials` | [認証](#could-not-load-aws-or-google-cloud-credentials) |
| `AWS default-chain credential resolve timed out` | [認証](#aws-default-chain-credential-resolve-timed-out) |
| `Timed out after 60s waiting for AWS` | [認証](#bedrock-setup-verification-timed-out-waiting-for-aws) |
| `A request to AWS timed out. Check your network and proxy settings, then try again.` | [認証](#bedrock-setup-verification-timed-out-waiting-for-aws) |
| `Could not load the default credentials` on Google Cloud's Agent Platform | [認証](#could-not-load-aws-or-google-cloud-credentials) |
| `Unable to connect to API` | [ネットワーク](#unable-to-connect-to-api) |
| `Connection refused —` / `Can't reach the API server —` / `No internet route —` / `Couldn't connect through your proxy` / `Connection dropped`、各々括弧内のエラーコードで終わる | [ネットワーク](#unable-to-connect-to-api) |
| `Unable to connect to Anthropic services` during setup | [ネットワーク](#unable-to-connect-to-anthropic-services) |
| `Socket is closed` | [ネットワーク](#socket-is-closed) |
| `Waiting for API response · will retry in` | [自動再試行](#automatic-retries)、または継続する場合は [ネットワーク](#unable-to-connect-to-api) |
| `API returned an empty or malformed response` | [ネットワーク](#api-returned-an-empty-or-malformed-response) |
| `Streaming response ended before any complete data was received` | [ネットワーク](#streaming-response-ended-before-any-complete-data-was-received) |
| `Bedrock streaming response has content-type "..."; expected "application/vnd.amazon.eventstream"` | [ネットワーク](#bedrock-streaming-response-has-an-unexpected-content-type) |
| `SSL certificate verification failed` | [ネットワーク](#ssl-certificate-errors) |
| `SSL certificate error (...)` during login or startup | [ネットワーク](#ssl-certificate-errors) |
| `unable to get local issuer certificate` | [ネットワーク](#ssl-certificate-errors) |
| `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session | [ネットワーク](#host-not-allowed-in-a-cloud-session) |
| `proxy refused the connection` | [ネットワーク](#the-proxy-refused-the-connection) |
| `403` with `GitHub GraphQL is not available from Claude Code sessions` in a cloud session | [GitHub proxy](/docs/ja/cloud-environments#github-proxy) |
| `The cloud environments service returned an empty response` / `The cloud environments service returned a response in an unexpected format` | [ネットワーク](#the-cloud-environments-service-returned-an-empty-or-unexpected-response) |
| `Couldn't reconnect to your Remote Control session` | [ネットワーク](#couldnt-reconnect-to-your-remote-control-session) |
| `N sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.` | [ネットワーク](#sessions-ended-while-this-machine-was-offline) |
| `Couldn't share the transcript.` | [ネットワーク](#couldnt-share-the-transcript) |
| `Couldn't send feedback` | [ネットワーク](#couldnt-send-feedback) |
| `Prompt is too long` / `Input is too long for requested model` | [リクエストエラー](#prompt-is-too-long) |
| `Prompt is too long · automatic compaction failed:` | [リクエストエラー](#prompt-is-too-long) |
| `Prompt is too long · this conversation is a single exchange` / `A single-exchange conversation cannot be compacted` | [リクエストエラー](#prompt-is-too-long) |
| `Context limit reached · /compact or /clear to continue` | [リクエストエラー](#prompt-is-too-long) |
| `Context limit reached · /clear to continue` | [リクエストエラー](#prompt-is-too-long) |
| `capability_rejected: prompt_too_long` on a Claude apps gateway session | [リクエストエラー](#prompt-is-too-long) |
| `upstream rejected the request` / `request too large for this upstream` on a Claude apps gateway session | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages) |
| `upstream rate limit exceeded` on a Claude apps gateway session | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages) |
| `all upstreams failed (N attempted)` on a Claude apps gateway session | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages) |
| `Claude Code may not be enabled for your organization` after a Claude apps gateway sign-in | [Claude apps gateway troubleshooting](/docs/ja/claude-apps-gateway-deploy#troubleshooting) |
| `Context exceeds the ...-token limit by ... tokens` in `/context` output | [リクエストエラー](#context-exceeds-the-token-limit) |
| `Request too large` | [リクエストエラー](#request-too-large) |
| `Request too large for the API's 32MB request limit` | [リクエストエラー](#request-too-large) |
| `Image was too large` | [リクエストエラー](#image-was-too-large) |
| `Unable to resize image` | [リクエストエラー](#unable-to-resize-image) |
| `PDF too large` / `PDF is password protected` / `pdftoppm is not installed` | [リクエストエラー](#pdf-errors) |
| `Extra inputs are not permitted` | [リクエストエラー](#extra-inputs-are-not-permitted) |
| `API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid` / `Property keys should match pattern` | [リクエストエラー](#tool-input-schema-is-invalid) |
| `tool_use.name: String should have at most 200 characters` | [リクエストエラー](#tool-use-name-over-200-characters) |
| `There's an issue with the selected model` | [リクエストエラー](#theres-an-issue-with-the-selected-model) |
| `Model ... is not a recognized model id` | [リクエストエラー](#model-is-not-a-recognized-model-id) |
| `Model ... not found` | [リクエストエラー](#model-not-found) |
| `Couldn't confirm model ... with the API` | [リクエストエラー](#couldnt-confirm-model-with-the-api) |
| `API error: ... · model not changed` | [リクエストエラー](#api-error-model-not-changed) |
| `Claude Opus is not available with the Claude Pro plan` | [リクエストエラー](#claude-opus-is-not-available-with-the-claude-pro-plan) |
| `Claude Code ... does not support this model; version ... or newer is required` | [リクエストエラー](#claude-code-does-not-support-this-model) |
| `Claude Code ... is older than the minimum version required by your organization's policy` | [リクエストエラー](#claude-code-does-not-support-this-model) |
| `Model ... is restricted by your organization's settings` | [リクエストエラー](#model-is-restricted-by-your-organizations-settings) |
| `Model ... is not available. Your organization restricts model selection.` | [リクエストエラー](#model-is-restricted-by-your-organizations-settings) |
| `Can't switch to the default model` | [リクエストエラー](#cant-switch-to-the-default-model) |
| `Model switch ... blocked by a PreModelSwitch hook` | [リクエストエラー](#model-switch-was-blocked-by-a-premodelswitch-hook) |
| `couldn't save it as your default` / `couldn't confirm it was saved as your default` | [リクエストエラー](#couldnt-save-it-as-your-default) |
| `is less capable than the current main model` / `Advisor will not activate on the main model` / `cannot advise` | [リクエストエラー](#advisor-is-less-capable-than-the-current-main-model) |
| `thinking.type.enabled is not supported for this model` | [リクエストエラー](#thinking-type-enabled-is-not-supported-for-this-model) |
| `Effort '<level>' isn't available with thinking turned off on this model` | [リクエストエラー](#effort-isnt-available-with-thinking-turned-off) |
| `effort '<level>' is not supported when thinking is disabled` | [リクエストエラー](#effort-isnt-available-with-thinking-turned-off) |
| `max_tokens must be greater than thinking.budget_tokens` | [リクエストエラー](#thinking-budget-exceeds-output-limit) |
| `API Error: 400 due to tool use concurrency issues` | [リクエストエラー](#tool-use-or-thinking-block-mismatch) |
| `API Error: 400 orphaned tool_result in conversation history` | [リクエストエラー](#tool-use-or-thinking-block-mismatch) |
| `API Error: 400 duplicate tool_use ID in conversation history` | [リクエストエラー](#tool-use-or-thinking-block-mismatch) |
| `Invalid data in redacted_thinking block` | [リクエストエラー](#invalid-data-in-redacted-thinking-block) |
| `[Unsupported tool content removed]` | [リクエストエラー](#unsupported-tool-content-removed) |
| `role 'system' must precede an 'assistant' message` | [リクエストエラー](#role-system-must-precede-an-assistant-message) |
| `Invalid encrypted_content in search_result block` / `Invalid encrypted_index in text block` / `Failed to decrypt web search result content` | [リクエストエラー](#invalid-encrypted-content-in-search-result-block) |
| `Invalid encrypted_stdout in encrypted_code_execution_result block` | [リクエストエラー](#invalid-encrypted-content-in-search-result-block) |
| `server_tool_use.name: Input should be` on every turn of a resumed session | [リクエストエラー](#unsupported-tool-content-removed) |
| `<model> can't help with this. Start a new session to continue` | [リクエストエラー](#usage-policy-refusal) |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy` | [リクエストエラー](#usage-policy-refusal) |
| `<model>'s safeguards flagged this message` | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic) |
| `<model>'s safeguards flagged this session` | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic) |
| `<model> has safety measures that flagged this message for a cybersecurity topic` | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic) |
| `` Details: `[reasoning_extraction]` `` | [リクエストエラー](#safeguards-flagged-a-request-for-claudes-reasoning) |
| `API Error: Output blocked by content filtering policy` | [リクエストエラー](#output-blocked-by-content-filtering-policy) |
| `Installation was killed before it could finish (exit code 137)` | [インストールエラー](#installation-was-killed-before-it-could-finish) |
| `The connection dropped while downloading the update` | [インストールエラー](#the-connection-dropped-while-downloading-the-update) |
| `Download timed out: exceeded the total deadline` | [インストールエラー](#the-connection-dropped-while-downloading-the-update) |
| `--bg and --print conflict` | [コマンドラインエラー](#conflict-between-bg-and-print) |
| `Error: Cannot use both --append-subagent-system-prompt and --append-subagent-system-prompt-file. Please use only one.` | [コマンドラインエラー](#conflict-between-a-system-prompt-flag-and-its-file-form) |
| `Cloud sessions cannot be created from a --restricted session` | [コマンドラインエラー](#cloud-sessions-cannot-be-created-from-a-restricted-session) |
| `Cloud sessions are disabled by your organization's policy` | [コマンドラインエラー](#cloud-sessions-are-disabled-by-your-organizations-policy) |
| `Couldn't verify your organization's policy for cloud sessions` | [コマンドラインエラー](#cloud-sessions-are-disabled-by-your-organizations-policy) |
| `Cloud sessions need a claude.ai sign-in` | [Unable to get organization UUID](/docs/ja/claude-code-on-the-web#unable-to-get-organization-uuid) |
| `Error: --json-schema is not a valid JSON Schema` | [コマンドラインエラー](#the-json-schema-value-is-not-a-valid-json-schema) |
| `Error: Invalid --agents configuration:` | [コマンドラインエラー](#invalid-agents-configuration) |
| `Error: --agents takes a JSON object, or a file path only with --print (-p)` | [コマンドラインエラー](#invalid-agents-configuration) |
| `Error: --agents file not found` | [コマンドラインエラー](#invalid-agents-configuration) |
| `Error: Settings file exceeds the 2MiB limit` | [コマンドラインエラー](#settings-file-exceeds-the-2mib-limit) |
| `The current directory no longer exists (it was deleted or moved)` / `Can't read the current directory` | [コマンドラインエラー](#the-current-directory-no-longer-exists) |
| `Temp directory <dir> ... Refusing to use it` / `ENOSPC: no space left on device, mkdir '<dir>'` | [コマンドラインエラー](#temp-directory-refused-or-cannot-be-created) |
| `couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded` | [コマンドラインエラー](#directory-couldnt-be-resolved-to-a-real-location) |
| `Error: Workspace not trusted` when starting Remote Control | [コマンドラインエラー](#workspace-not-trusted-when-starting-remote-control) |
| `` `<flag>` before `remote-control` is not carried over to the sessions Remote Control starts `` | [コマンドラインエラー](#not-carried-over-to-the-sessions-remote-control-starts) |
| `` `claude import` is not yet available in this build `` | [コマンドラインエラー](#claude-import-is-not-yet-available-in-this-build) |
| `Could not read Claude Code config` | [コマンドラインエラー](#could-not-read-claude-code-config) |
| `Could not import <server>: <reason>` | [コマンドラインエラー](#could-not-import-a-server-from-claude-desktop) |
| `Cannot add MCP server to scope: managed` | [コマンドラインエラー](#cannot-add-mcp-server-to-the-managed-scope) |
| `Cannot add MCP server: your organization's managed settings allow only MCP servers that plugins provide` | [コマンドラインエラー](#cannot-add-mcp-server-when-managed-settings-allow-only-plugin-servers) |
| `is Anthropic-hosted and doesn't support local OAuth` | [コマンドラインエラー](#anthropic-hosted-and-doesnt-support-local-oauth) |
| `Can't read .mcp.json: it isn't a regular file or is larger than 2097152 bytes` | [コマンドラインエラー](#cant-read-mcp-json) |
| `MCP server "<name>" was not saved to` / `was not removed from` | [コマンドラインエラー](#mcp-server-was-not-saved-or-removed) |
| `MCP server "<name>" may not have been saved` / `may not have been removed` | [コマンドラインエラー](#mcp-server-may-not-have-been-saved-or-removed) |
| `Server rejected the Authorization header minted by the configured headersHelper` | [コマンドラインエラー](#server-rejected-the-authorization-header-minted-by-the-configured-headershelper) |
| `Error: MCP tool <name> (passed via --permission-prompt-tool) not found` | [コマンドラインエラー](#mcp-permission-prompt-tool-not-found) |
| `OAuth callback port <port> is already in use — another process may be holding it` | [コマンドラインエラー](#oauth-callback-port-is-already-in-use) |
| `No available ports for OAuth redirect` | [コマンドラインエラー](#no-available-ports-for-oauth-redirect) |
| `Shell command failed for pattern "..."`, from `/security-review` or any skill that injects dynamic context | [コマンドラインエラー](#security-review-fails-without-origin-head) |
| `Shell command permission check failed for pattern "..."`, from a skill that injects dynamic context | [コマンドラインエラー](#security-review-fails-without-origin-head) |
| ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found`` | [コマンドラインエラー](#security-review-fails-without-origin-head) |
| `Input must be provided either through stdin or as a prompt argument when using --print` | [コマンドラインエラー](#input-must-be-provided-when-using-print) |
| `Claude Code can't read the keyboard here: stdin is not a terminal` | [コマンドラインエラー](#claude-code-cant-read-the-keyboard-here) |
| `Error: Input contained only whitespace` | [コマンドラインエラー](#input-contained-only-whitespace) |
| `Blank prompt — the message was only whitespace, so nothing was sent to the model.` | [コマンドラインエラー](#input-contained-only-whitespace) |
| `Error: stream-json input carried over 256M characters with no newline` | [コマンドラインエラー](#stream-json-input-carried-over-256m-characters-with-no-newline) |
| `Unknown command: /<name>`, with or without a `Did you mean` suggestion | [コマンドラインエラー](#unknown-command) |
| `Diff is too large for ultrareview` / `PR #<N> is too large for ultrareview` | [コマンドラインエラー](#diff-is-too-large-for-ultrareview) |
| `Could not find merge-base with <branch>` | [コマンドラインエラー](#could-not-find-merge-base-with-the-base-branch) |
| `Your checkout has no branches (detached HEAD only)` | [コマンドラインエラー](#your-checkout-has-no-branches) |
| `Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected` | [コマンドラインエラー](#no-github-account-is-connected-to-your-claude-account) |
| `Your connected GitHub account can't see <owner>/<repo>` | [コマンドラインエラー](#your-connected-github-account-cant-see-the-repository) |
| `The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead` | [コマンドラインエラー](#the-github-app-preflight-failed-transiently) |
| `Not uploading this working tree` with `the upload cannot follow that setting` | [コマンドラインエラー](#the-repository-upload-cant-follow-a-git-setting) |
| `GitHub isn't connected to your Claude account, so this repository can't be cloned in the cloud` | [コマンドラインエラー](#github-isnt-connected-to-your-claude-account) |
| `Your GitHub organization has an IP allowlist that is blocking Claude` | [コマンドラインエラー](#a-github-organization-policy-is-blocking-claude) |
| `Your GitHub organization requires single sign-on` | [コマンドラインエラー](#a-github-organization-policy-is-blocking-claude) |
| `Your GitHub organization's identity provider (Microsoft Entra ID) has a Conditional Access policy that is blocking Claude` | [コマンドラインエラー](#a-github-organization-policy-is-blocking-claude) |
| `Single sign-on authorization needed` | [コマンドラインエラー](#single-sign-on-authorization-needed) |
| `Failed to resume the conversation` | [コマンドラインエラー](#failed-to-resume-the-conversation) |
| `No conversation found with session ID: <session-id>` | [コマンドラインエラー](#no-conversation-found-with-the-session-id) |
| `Windows reported an error (EBADF) when Claude Code read this session's transcript file` | [コマンドラインエラー](#windows-reported-an-error-ebadf) |
| `Cannot switch renderers in this session` | [コマンドラインエラー](#cannot-switch-renderers-in-this-session) |
| `Cannot switch renderers while work is running in the background` | [コマンドラインエラー](#cannot-switch-renderers-in-this-session) |
| `Couldn't open Claude Desktop` | [コマンドラインエラー](#couldnt-open-claude-desktop) |
| `Failed to open Claude Desktop. Please try opening it manually.` | [コマンドラインエラー](#couldnt-open-claude-desktop) |
| `Couldn't read your Zed keymap` / `Couldn't back up your Zed keymap` / `Couldn't update your Zed keymap` | [コマンドラインエラー](#terminal-setup-left-your-zed-keymap-unchanged) |
| `Your Zed keymap isn't a readable list of keybindings` | [コマンドラインエラー](#terminal-setup-left-your-zed-keymap-unchanged) |
| `Skill usage reports are not available on this connection.` | [コマンドラインエラー](#skill-usage-reports-are-not-available-on-this-connection) |
| `Custom output styles can't be selected over Remote Control or from a relayed message` | [コマンドラインエラー](#custom-output-styles-cant-be-selected-over-remote-control) |
| `Output styles are saved to local settings (.claude/settings.local.json), which this session doesn't load` | [コマンドラインエラー](#output-styles-are-saved-to-local-settings-which-this-session-doesnt-load) |
| `/recap only runs when you ask for it yourself in this session` | [コマンドラインエラー](#recap-only-runs-when-you-ask-for-it-yourself) |
| `` `plugin eval` is currently in early access `` / `` `plugin eval` is currently unavailable `` | [プラグインエラー](#plugin-eval-is-currently-in-early-access) |
| `Marketplace "<name>" is registered from an untrusted source` | [プラグインエラー](#marketplace-is-registered-from-an-untrusted-source) |
| `Claude Code refuses the marketplace name "<name>"` | [プラグインエラー](#claude-code-refuses-the-marketplace-name) |
| `Marketplace name impersonates an official Anthropic/Claude marketplace` | [プラグインエラー](#claude-code-refuses-the-marketplace-name) |
| `Marketplace "<name>" is already added from a different source` | [プラグインエラー](#marketplace-is-already-added-from-a-different-source) |
| `"<name>" is another spelling of "<reserved>", a reserved marketplace name` | [プラグインエラー](#marketplace-name-is-another-spelling-of-a-reserved-name) |
| `Marketplace "<name>" is added but ignored` | [プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting#marketplace-is-added-but-ignored) |
| `Marketplace "<name>" is registered but was refused (see the debug log)` | [プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting#marketplace-is-added-but-ignored) |
| `references ${user_config.*} in a shell-form command` | [プラグインエラー](#plugin-command-references-user-config) |
| `Monitor "<name>" from plugin <plugin> references ${user_config.*} in its command` | [プラグインエラー](#plugin-command-references-user-config) |
| `headersHelper for MCP server '<name>' references ${user_config.*}` | [プラグインエラー](#plugin-command-references-user-config) |
| `Plugin archive integrity check failed` | [プラグインエラー](#plugin-archive-integrity-check-failed) |
| `An npm plugin source must name a registry package` | [プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting#an-npm-plugin-source-must-name-a-registry-package) |
| `The packages it lists are not installed` / `The packages it lists were not installed, because` | [プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting#the-packages-it-lists-are-not-installed) |
| `path escapes plugin directory` | [プラグインエラー](#path-escapes-plugin-directory) |
| `path could not be checked` | [プラグインエラー](#path-could-not-be-checked) |
| `its marketplace entry path does not stay inside the marketplace directory` | [プラグインエラー](#marketplace-entry-path-does-not-stay-inside-the-marketplace-directory) |
| `Plugin source path refused` | [プラグインエラー](#marketplace-entry-path-does-not-stay-inside-the-marketplace-directory) |
| `Failed to load marketplace configuration` | [プラグインエラー](#failed-to-load-marketplace-configuration) |
| `Marketplace configuration file is corrupted` | [プラグインエラー](#failed-to-load-marketplace-configuration) |
| `Plugin "<name>@synced" is required by your organization and can't be disabled here` | [プラグインエラー](#plugin-is-required-by-your-organization) |
| `"<plugin>" was not uninstalled: it is still switched on in <file>` | [プラグインエラー](#plugin-was-not-uninstalled) |
| `"<plugin>" was not uninstalled: <file> is there and could not be read` | [プラグインエラー](#plugin-was-not-uninstalled) |
| `Plugin "<plugin>" was not uninstalled: installed_plugins.json` | [プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting#installed-plugins-json-holds-a-record-this-version-cannot-read) |
| `Error: No such tool available: <tool name>` | [ツールエラー](#no-such-tool-available) |
| `would be spawned with zero tools — refusing` | [ツールエラー](#agent-would-be-spawned-with-zero-tools) |
| `File is covered by a Read deny rule in your permission settings` | [ツールエラー](#file-is-covered-by-a-read-deny-rule) |
| `cannot contain null bytes (\0)` | [ツールエラー](#path-cannot-contain-null-bytes) |
| `Path contains null bytes` | [ツールエラー](#path-cannot-contain-null-bytes) |
| `subagent_type is required: the general-purpose agent is not available in this session` | [ツールエラー](#subagent-type-is-required) |
| `Error: this write left the memory index at MEMORY.md at ..., over its ... read limit` | [ツールエラー](#memory-index-is-over-its-read-limit) |
| `pkill: refusing to run` | [ツールエラー](#pkill-pattern-matches-the-claude-code-process) |
| `Failed to write to <name>'s inbox — nothing was sent` | [ツールエラー](#failed-to-write-to-a-teammate-inbox) |
| `Failed to write the plan approval request to the lead's inbox — plan not submitted` | [ツールエラー](#failed-to-write-to-a-teammate-inbox) |
| `Its agent definition was not restored: the folder its definition file came from is not trusted` | [ツールエラー](#teammate-agent-definition-not-restored) |
| `Message too large for cross-session delivery` | [ツールエラー](#message-too-large-for-cross-session-delivery) |
| `Too many messages to this session just now` | [ツールエラー](#too-many-messages-to-this-session-just-now) |
| `Cross-session message was dropped at the recipient session's inbox` | [ツールエラー](#cross-session-message-dropped-at-the-inbox) |
| `Refusing to send: reply target is a symlink` / `Refusing to send: cannot vet reply target` | [ツールエラー](#refusing-to-send-a-cross-session-message) |
| `Refusing to read <path>: its symlink resolution changed after permission was checked (<reason>)` / `Refusing to search <path>: its symlink resolution changed after permission was checked` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `Refusing to write <path>: its parent-directory symlink resolution changed after permission was checked` / `Refusing to write <path>: it is a symbolic link. Write to the link's target path instead` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `Refusing to write through symlink: <path>` / `Refusing to write into symlinked directory: <path>` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `Refusing to write <path>: where it leads on disk could not be determined` / `Refusing to read <path>: where it leads on disk could not be determined` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `Refusing to search <path>: a path one of its Read deny rules is written through changed while the search was being prepared` / `Refusing to search <path>: it could not be opened` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `its permission check expired before it ran (too many concurrent file operations)` / `ripgrep was found only by name on PATH` | [ツールエラー](#refusing-after-a-symlink-changed) |
| `task output swap refused (tasks dir moved or linked)` | [ツールエラー](#task-output-swap-refused) |
| `Command killed: its output file was replaced or could no longer be verified` | [ツールエラー](#task-output-swap-refused) |
| `Your disk quota is full on the filesystem with Claude Code's temp directory <dir> (EDQUOT)` | [ツールエラー](#disk-quota-or-temp-filesystem-is-full) |
| `The filesystem with Claude Code's temp directory <dir>, or your disk quota on it, is full (ENOSPC)` | [ツールエラー](#disk-quota-or-temp-filesystem-is-full) |
| `Command output was lost: the temp filesystem at <dir> is full` / `is out of inodes` | [ツールエラー](#disk-quota-or-temp-filesystem-is-full) |
| `the source file is not valid UTF-8 text` / `the source file is not valid UTF-16 text` | [ツールエラー](#the-source-file-is-not-valid-utf-8-text) |
| `the source file has the replacement character U+FFFD` | [ツールエラー](#the-source-file-is-not-valid-utf-8-text) |
| `Not published: that file is on a network share` | [ツールエラー](#not-published-that-file-is-on-a-network-share) |
| `Reading a local file from outside this session's connected folders, or through a link, needs the approval card` | [ツールエラー](#reading-a-local-file-from-outside-the-connected-folders) |
| `cannot read file_path (...) — the file could not be examined, and no one can answer the approval card` | [ツールエラー](#reading-a-local-file-from-outside-the-connected-folders) |
| `WebFetch cannot fetch localhost or other hostnames without a dot` | [ツールエラー](#webfetch-cannot-fetch-localhost) |
| `The safety check for domain ... is rate-limited` | [ツールエラー](#webfetch-domain-safety-check-failed) |
| `The safety check for domain ... is temporarily rate-limited` | [ツールエラー](#webfetch-domain-safety-check-failed) |
| `Unable to verify if domain ... is safe to fetch` | [ツールエラー](#webfetch-domain-safety-check-failed) |
| `Can't open MCP settings while no terminal is attached to this background session` | [バックグラウンドセッションエラー](#commands-refused-in-a-background-session) |
| `Can't open MCP settings in a background session` | [バックグラウンドセッションエラー](#commands-refused-in-a-background-session) |
| `blocked because the path is spelled in a form that cannot be safely resolved` | [バックグラウンドセッションエラー](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved) |
| `blocked because the path is network-shaped` | [バックグラウンドセッションエラー](#write-or-command-blocked-because-the-path-names-a-network-location) |
| `is isolated in the worktree <path>, but this command <reason>. Refusing to run it` | [バックグラウンドセッションエラー](#command-blocked-by-the-worktree-isolation-checks) |
| `too complex to verify that it stays inside the worktree` | [バックグラウンドセッションエラー](#command-blocked-by-the-worktree-isolation-checks) |
| `This session has no saved transcript` | [バックグラウンドセッションエラー](#this-session-has-no-saved-transcript) |
| `Can't open — this session is running in another terminal` | [バックグラウンドセッションエラー](#this-session-is-running-in-another-terminal) |
| `This conversation is already open in another running Claude session` | [バックグラウンドセッションエラー](#this-session-is-running-in-another-terminal) |
| `This session's saved conversation is no longer on disk` | [バックグラウンドセッションエラー](#this-sessions-saved-conversation-is-no-longer-on-disk) |
| `kept <id> — its worktree is still at <path>` | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere) |
| `kept <id> — <n> unpushed commits on <branch>` | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere) |
| `kept <id> — worktree has commits that are not pushed anywhere` | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere) |
| `terminal host process died — press Enter to restart` / `This session's terminal host process died` | [バックグラウンドセッションエラー](#terminal-host-process-died) |
| `Session isn't responding` / `Press enter again to restart this session — it isn't responding` | [バックグラウンドセッションエラー](#session-isnt-responding) |
| `Session <id> was stopped while the respawn was in flight` | [バックグラウンドセッションエラー](#session-was-stopped-while-the-respawn-was-in-flight) |
| `This session was running agent '<name>', which is no longer available` | [バックグラウンドセッションエラー](#session-agent-no-longer-available) |
| `CLAUDE_CODE_PROCESS_WRAPPER: launcher ...` | [バックグラウンドセッションエラー](#claude_code_process_wrapper-launcher-errors) |
| `EUNKNOWN: unknown error, uv_spawn` | [バックグラウンドセッションエラー](#eunknown-when-starting-a-background-session) |
| `EACCES: permission denied, posix_spawn` | [バックグラウンドセッションエラー](#eacces-when-starting-a-background-session) |
| `exited before it became reachable` | [バックグラウンドセッションエラー](#background-service-exited-before-it-became-reachable) |
| `Couldn't start a background session (working directory no longer exists or is not accessible: ...)` | [バックグラウンドセッションエラー](#working-directory-no-longer-exists-when-starting-a-background-session) |
| `Workspace not trusted.` when starting or restarting a background session | [バックグラウンドセッションエラー](#workspace-not-trusted-when-dispatching-a-background-session) |
| `Claude Code is being updated by npm on this machine (still not runnable after 2 min, ...)` | [バックグラウンドセッションエラー](#eacces-when-starting-a-background-session) |
| `Claude Code process exited with code N` | [ラッパーと IDE エラー](#claude-code-process-exited-with-code-n) |
| `The connection to Claude Code ended before this message completed` | [ラッパーと IDE エラー](#the-connection-to-claude-code-ended-before-this-message-completed) |
| `Could not locate the Claude CLI on PATH` | [ラッパーと IDE エラー](#could-not-locate-the-claude-cli-on-path) |
| `Restored the code, but skipped N files` | [Rewind の警告とエラー](#restored-the-code-but-skipped-files) |
| `No files were restored: N files failed (backup missing, or the file could not be updated)` | [Rewind の警告とエラー](#no-files-were-restored) |
| `Transcript writes are failing (...)` | [セッション保存の警告](#transcript-writes-are-failing) |
| `Transcript saving is off — CLAUDE_CODE_SKIP_PROMPT_HISTORY is set` | [セッション保存の警告](#transcript-saving-is-off-skip-prompt-history) |
| `Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker` | [セッション保存の警告](#transcript-saving-is-off-child-session-marker) |
| `Claude Code's fullscreen renderer didn't finish starting last time on this machine` / `Claude Code's fullscreen renderer has repeatedly failed to start on this machine` | [フルスクリーンレンダリング](/docs/ja/fullscreen#fullscreen-renderer-didnt-finish-starting) |
| `Claude Code exited after an unrecoverable interface error (...)` | [設定の警告](#exited-after-an-unrecoverable-interface-error) |
| `Agent descriptions are over the 15.0k-token limit` | [設定の警告](#agent-descriptions-are-over-the-15000-token-limit) |
| `Not loaded: rename <path>, then restart — its name uses "<name>", a name reserved for the skills synced from your claude.ai account` | [設定の警告](#a-skill-command-or-workflow-wasnt-loaded-because-its-name-is-reserved) |
| `Ignoring N permissions.allow entries from ... this workspace has not been trusted` | [設定の警告](#workspace-has-not-been-trusted) |
| `is a network path, which cannot be added as a working directory` | [設定の警告](#working-directory-is-a-network-path) |
| `Remote managed settings failed to load (<cause>)` | [設定の警告](#remote-managed-settings-failed-to-load) |
| `Managed settings were not approved; exiting without applying them.` | [設定の警告](#managed-settings-were-not-approved) |
| `Claude Code can't start: your organization's managed settings block the default model` / `Claude Code can't start: your organization allows only the models listed in "availableModels"` | [設定の警告](#managed-settings-block-the-default-model) |
| `Your organization's managed settings allow Claude Code to use: <providers>` | [設定の警告](#managed-settings-dont-allow-this-api-provider) |
| `Your organization's managed settings allow Claude Code to use no API provider at all` | [設定の警告](#managed-settings-dont-allow-this-api-provider) |
| `MCP server <name> is blocked by enterprise managed policy` | [設定の警告](#mcp-server-is-blocked-by-enterprise-managed-policy) |
| `Managed settings document could not be parsed as a JSON object; none of its settings are in effect. Fix or remove it.` | [設定の警告](#managed-settings-document-could-not-be-parsed) |
| `Managed settings drop-in directory could not be read` | [設定の警告](#managed-settings-document-could-not-be-parsed) |
| `Unable to read managed policy settings` | [設定の警告](#unable-to-read-managed-policy-settings) |
| `otelHeadersHelper failed; telemetry is not being exported. See /status: ...` | [設定の警告](#otelheadershelper-failed) |
| `"crossSessionInbound" must be one of "accept", "hold", "refuse"` | [設定の警告](#crosssessioninbound-must-be-one-of-accept-hold-refuse) |
| `API Error: ANTHROPIC_FOUNDRY_RESOURCE must be a Foundry resource name` | [設定の警告](#anthropic-foundry-resource-must-be-a-foundry-resource-name) |
| `headersHelper not run — this workspace has no persisted trust` | [設定の警告](#headershelper-not-run) |
| `Invalid permission rule "..." was skipped: Malformed Tool(content) rule` | [設定の警告](#malformed-tool-content-rule) |
| `... is not matched by file permission checks` | [設定の警告](#is-not-matched-by-file-permission-checks) |
| `... has a wildcard before the rest of the command` | [設定の警告](#has-a-wildcard-before-the-rest-of-the-command) |
| `Denying Bash also turns off the PowerShell tool, so Claude has neither` | [設定の警告](#denying-bash-also-turns-off-the-powershell-tool) |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT is set, but the 200K limit isn't enforced` | [設定の警告](#the-200k-limit-isnt-enforced) |
| `[claude-code:unrecognized_model]` | [設定の警告](#unrecognized-model-id-on-a-request) |
| `Stale sandbox mask files left by a killed session` | [設定の警告](#stale-sandbox-mask-files-left-by-a-killed-session) |
| Responses seem lower quality than usual | [応答品質](#responses-seem-lower-quality-than-usual) |

<h2 id="automatic-retries">
  自動リトライ
</h2>

Claude Code は、エラーを表示する前に、指数バックオフを使用して一時的な障害を最大 10 回リトライします。Claude の応答の途中で到着した障害は常にリトライされるわけではありません。このページのエラーのいずれかが表示される場合、Claude Code はその障害に適用されるリトライを既に実行しています。

Claude Code がリトライする障害：

* Claude の応答がストリーミングされる前に到着するサーバーエラー、過負荷応答、およびリクエストタイムアウト。
* Claude が思考を完了した後、テキストまたはツール呼び出しを開始する前に到着するサーバーエラーまたは過負荷応答。Claude Code はその時点でのサーバーエラーを最大 2 回リトライします。v2.1.284 より前は、Claude Code はその時点でエラーとともにターンを終了していました。
* 接続の切断。Claude が応答の任意の部分（思考を含む）を完了する前にリクエストの途中で接続が切断された場合、Claude Code は同じバックオフでリクエストを再発行し、テキストがすでにストリーミングを開始していても、ターンは続行されます。Claude が思考を完了した後、テキストまたはツール呼び出しを開始する前に接続が切断された場合、Claude Code は代わりにリクエストを最大 2 回迅速に連続して再発行し、接続がその時点で切断され続ける場合は `Connection lost before a response was produced` でターンを終了します。
* リクエストの途中でコンピューターがスリープ状態になったことが原因で Claude Code が検出した接続の破損。Claude Code はこれを上記のルールに基づいて切断された接続としてカウントします。リトライラベルが特定の理由を名前付けすると、`Connection lost while your computer was asleep` と読み、Claude が思考を完了した後、テキストまたはツール呼び出しの前にターンが終了する場合、メッセージは `Your computer went to sleep before a response was produced` と読みます。
* 応答ヘッダーが到着したが Claude の応答が到着していない場合、または Claude が思考を完了したがテキストまたはツール呼び出しを開始していない場合の、停止した応答ストリーム。Claude Code は停止した接続を中止し、上記の 10 回の試行予算外で最大 1 回リクエストを再発行します。Claude が思考を完了した後、テキストまたはツール呼び出しの前に応答が 2 回目に停止した場合、Claude Code は `The response stalled before a response was produced` でターンを終了します。
* API が応答ヘッダーで応答しないストリーミングリクエスト。[最初のバイトデッドラインが実行される](/docs/ja/network-config#streaming-idle-watchdogs)接続上：Claude Code はデッドラインで中止し、リトライ予算内でモデルリクエストごとに最大 1 回再送信し、その試行も応答がない場合は [No response from API](#no-response-from-api) でターンを終了します。他の接続では、リクエストは `API_TIMEOUT_MS` を待ちます。`CLAUDE_CODE_RETRY_WATCHDOG` を設定する場合、1 回のリトライ上限は適用されません。
* Claude が思考を完了するか、テキストまたはツール呼び出しを開始する前に、API の出力コンテンツフィルターが停止したストリーミング応答。Claude Code はリトライ予算内でリクエストを 1 回再送信し、フィルターが 2 回目の応答も停止した場合は [Output blocked by content filtering policy](#output-blocked-by-content-filtering-policy) を表示します。
* 一時的な 429 スロットル。ただし、ゲートウェイの支出制限 `429` は除きます。これはスロットルではありません。[Spend limit reached](#spend-limit-reached) を参照してください。
  * claude.ai サブスクリプションでサインインしている場合、これには計画の割り当てヘッダーを含まない 429 スロットルが含まれます。v2.1.199 より前は、Claude Code は API キーおよび Enterprise サインインに対してのみこれらのスロットルをリトライしました。
* 入力と `max_tokens` がコンテキスト制限を超えるため拒否されたリクエスト。変更されていない状態で再送信すると同じ方法で失敗するため、Claude Code は削減された `max_tokens` でリトライし、2 つのケースでリトライを停止してコンパクト化する代わりに：
  * 削減がフィットできない場合。例えば、会話自体がコンテキストウィンドウをほぼ満たしている場合。
  * リトライが `max_tokens` をこれ以上縮小できない場合。v2.1.218 より前は、Claude Code は、拡張思考予算が残りのコンテキストを超えた場合など、フィットしない削減されたリクエストを再送信でき、リトライ予算が尽きるまで続きました。
* [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) 上の期限切れまたは欠落している Google Cloud 認証情報、またはマシンで読み込みに失敗した AWS 認証情報。Claude Code はキャッシュされた認証情報を破棄し、最大 2 回リトライしてから、[Could not load AWS or Google Cloud credentials](#could-not-load-aws-or-google-cloud-credentials) で説明されているように、すぐに再認証できるようにエラーを報告します。v2.1.228 より前は、Claude Code は失敗した Google Cloud 認証情報を完全なリトライ予算を通じてリトライしてからエラーを表示していました。
* [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトが認証情報を提供している間に、Anthropic API から直接、または [LLM gateway](/docs/ja/llm-gateway) を通じて `401` または `403`。Claude Code はスクリプトを再実行し、完全なリトライ予算内でその新しい出力でリトライします。スクリプト自体が再実行時に失敗する場合、Claude Code は [Your apiKeyHelper script is failing](#your-apikeyhelper-script-is-failing) を代わりに表示します。

v2.1.227 より前は、`Connection lost before a response was produced` は `Connection closed while thinking, before producing a response` と読み、`The response stalled before a response was produced` は `Response stalled while thinking, before producing a response` と読みました。

Claude Code がリトライしない障害：

* TLS 証明書検証エラー。TLS 検査プロキシ、欠落している `NODE_EXTRA_CA_CERTS` バンドル、または期限切れの証明書など。Claude Code は最初の試行でエラーを報告するため、証明書セットアップをすぐに修正できます。[SSL certificate errors](#ssl-certificate-errors) を参照してください。Claude Code は依然としてハンドシェイクタイムアウトなどの一時的な TLS 条件をリトライします。v2.1.199 より前は、Claude Code は証明書エラーを完全なリトライ予算を通じてリトライしてからエラーを表示していました。
* Claude がテキストのブロックまたはツール呼び出しを完了した後、または思考を完了した後にそれを開始した後、応答を完了する前に到着するサーバーエラー、切断された接続、または停止したストリーム。Claude Code はリクエストを再実行しません。これは同じツール呼び出しを 2 回実行する可能性があるためです。Claude が完了したものを保持し、Claude が完了したツール呼び出しを実行し、その結果からターンを続行します。対話型セッションと非対話型セッションで表示される内容については、[The response above may be incomplete](#the-response-above-may-be-incomplete) を読んでください。v2.1.199 より前は、サーバーエラーがストリーム中に到着した場合、Claude Code は部分的な出力を破棄し、ターン全体をエラーとして報告していました。
* Claude が応答を完了した後に到着する障害：リトライする必要がないため、Claude Code は完全な応答を保持し、ターンを正常に終了します。
* [Amazon Bedrock ストリーミング応答に予期しないコンテンツタイプがある](#bedrock-streaming-response-has-an-unexpected-content-type)。ゲートウェイまたはプロキシが応答を書き直すため、リトライも同じ方法で書き直されます。Claude Code v2.1.208 以降が必要です。
* 失敗したストリーミングリクエストの非ストリーミングリトライが成功ステータスを取得しますが、[本文に Claude API メッセージがない](#api-returned-an-empty-or-malformed-response)。Claude Code はそのエラーでターンを終了します。
* 組織のポリシーチェックが拒否したリクエスト。これは `API Error:` 行として表示され、拒否メッセージが含まれます。組織の管理者は [Inference hooks](https://platform.claude.com/docs/en/manage-claude/inference-hooks) を使用してチェックを設定します。これは Claude Enterprise 機能であり、メッセージは彼らが設定した指示で終わるか、デフォルトでは彼らに連絡するよう指示します。Claude Code は、拒否がリクエストのコンテンツに関するものであり、モデルに関するものではないため、拒否されたリクエストを同じモデルまたは [fallback model](/docs/ja/model-config#fallback-model-chains) に再送信しません。v2.1.239 より前は、Claude Code は拒否されたリクエストを、ストリーミングなしで、または設定されたフォールバックモデルで再送信してから、拒否を表示する可能性がありました。

<h3 id="what-you-see-while-claude-code-retries-or-waits">
  Claude Code がリトライまたは待機している間に表示される内容
</h3>

リトライ中、スピナーはエラーラベルの後に `Retrying in Ns · attempt x/y` カウントダウンを表示します。ラベルは、すぐに対応できる障害の最初の試行からの特定の理由を名前付けします。ネットワークがダウンしている、TLS ハンドシェイクが失敗した、またはレート制限に達した場合です。他のエラーの場合は、最初は `API error` と読みます。v2.1.198 以降、3 回目の試行からの特定の理由に切り替わるか、`CLAUDE_CODE_MAX_RETRIES` が 3 未満の試行を許可する場合は最終試行時に切り替わります。以前のバージョンは最終試行時にのみ切り替わります。

v2.1.198 以降、通常のスピナーのヒントはリトライ中に抑制されます。エラーの理由が明らかになると、障害が 529 オーバーロードの場合、カウントダウンの下の行はサービスステータスを確認する場所も名前付けします。Anthropic API の場合は `status.claude.com`、または他の設定の場合はメッセージで名前付けされたプロバイダーまたはゲートウェイホスト。

リクエストがまだ保留中の間に応答ストリームで 20 秒間データが到着しない場合、スピナーは任意のリトライが開始される前に `Waiting for API response · will retry in … · check your network` を表示します。リクエストはまだ失敗していません。カウントダウンは Claude Code が停止した接続を中止する時点まで実行されます。中止後、表示される内容は応答がどこまで進んだかによって異なります。

* Claude がテキストのブロックまたはツール呼び出しを完了する前、または思考を完了した後にそれを開始する前に、Claude Code はリクエストをリトライするか、エラーでターンを終了します。[Automatic retries](#automatic-retries) は、どのストールをリトライするか、何回リトライするかを示しています。
* Claude がテキストのブロックまたはツール呼び出しを完了した後、または思考を完了した後にそれを開始した後、応答を完了する前に、Claude Code は Claude が完了したものを保持し、Claude が完了したツール呼び出しからターンを続行し、[The response above may be incomplete](#the-response-above-may-be-incomplete) を表示します。非対話型セッション、およびいずれかのセッションでサブエージェントの応答の場合、Claude Code は最初に Claude に応答を続行するよう促す可能性があります。そのエントリは、いつそれを行うか、いつそこでも通知が表示されるかを示しています。
* Claude が応答を完了した後、Claude Code はターンを正常に終了します。

バナーは、データが再開されるか、リトライが成功すると自動的にクリアされます。すべての試行で再表示される場合は、[network issue](#unable-to-connect-to-api) として扱ってください。v2.1.185 より前は、バナーは 10 秒後に異なる文言で表示されました。

Claude が [advisor](/docs/ja/advisor) を参照している間、バナーは 20 秒ではなく 90 秒後にデータなしで表示されます。長いアドバイザーレビューは 20 秒以上何も送信しないことがあるためです。v2.1.214 より前は、20 秒のしきい値がアドバイザー呼び出し中にも適用されたため、バナーは何も問題がなくてもアドバイザーレビュー中に表示されました。

<h3 id="tune-retry-behavior">
  リトライ動作を調整する
</h3>

これらの環境変数を使用してリトライ動作を調整できます。

| 変数 | デフォルト | 効果 |
| :- | :- | :- |
| [`CLAUDE_CODE_MAX_RETRIES`](/docs/ja/env-vars) | 10 | リトライ試行の回数。v2.1.186 以降は 15 でキャップされます。v2.1.199 以降、`CLAUDE_CODE_RETRY_WATCHDOG` はデフォルトを上げ、キャップを削除します。スクリプトで障害をより速く表示するには、これを低くしてください。 |
| [`CLAUDE_CODE_RETRY_WATCHDOG`](/docs/ja/env-vars) | 未設定 | CI ジョブなどの無人セッションで `1` に設定して、`CLAUDE_CODE_MAX_RETRIES` 試行後に失敗する代わりに、`429` および `529` 容量エラーを無期限にリトライします。Claude Code は、標準速度リクエストが支出制限または使用クレジットの枯渇を報告する `429` を取得する場合、スケジュールでリセットされる [gateway spend cap](#spend-limit-reached) からのものであっても、すぐに失敗します。v2.1.239 より前は、ウォッチドッグはこれらを無期限にリトライしていました。fast mode リクエストについては、[Handle rate limits](/docs/ja/fast-mode#handle-rate-limits) を参照してください。v2.1.199 以降では、サーバーエラー、タイムアウト、切断された接続などの他の一時的なエラーのデフォルトリトライ数も 300 に上げます。これは約 3 時間のバックオフであり、変数を明示的に設定する場合は `CLAUDE_CODE_MAX_RETRIES` の 15 のキャップを削除します。 |
| [`API_TIMEOUT_MS`](/docs/ja/env-vars) | 600000 | リクエストごとのタイムアウト（ミリ秒）。遅いネットワークまたはプロキシの場合は、これを上げてください。また、[No response from API](#no-response-from-api) で説明されている、Claude Code が応答ヘッダーを待つ時間の上限にもなります。 |
| [`CLAUDE_CODE_NONSTREAMING_TIMEOUT_RETRIES`](/docs/ja/env-vars) | 未設定 | タイムアウトした[非ストリーミングリクエスト](#streaming-response-ended-before-any-complete-data-was-received)の再送信回数の上限。上限に達すると、リクエストは失敗します。生成にタイムアウトより長くかかる Claude の応答は再送信のたびに再びタイムアウトするため、より早く失敗させるには `0` などの小さい値を設定してください。各非ストリーミング試行は、ローカルセッションでは 300 秒後、正の値を設定した場合は `API_TIMEOUT_MS` の経過後にタイムアウトします。Claude Code v2.1.285 以降が必要です。 |
| [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](/docs/ja/env-vars) | 未設定 | ストリーミングリクエストの最初の応答バイトのデッドライン（ミリ秒）。Claude Code v2.1.242 以降が必要です。これが未設定の場合に Claude Code がデッドラインを選択する方法については、[No response from API](#no-response-from-api) を参照してください。 |

<h2 id="server-errors">
  サーバーエラー
</h2>

これらのエラーのほとんどは推論プロバイダーから発生します。Anthropic API 上の Anthropic のサービス、および Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、またはカスタムゲートウェイの背後にあるプロバイダーのエンドポイントのサービスです。[Auto mode cannot determine the safety of an action](#auto-mode-cannot-determine-the-safety-of-an-action) と [Agent terminated early due to an API error](#agent-terminated-early-due-to-an-api-error) は、Amazon Bedrock アカウントが分類器モデルを呼び出せない、またはサブエージェントが使用制限に達したなど、ユーザー側の原因もカバーしています。

<h3 id="api-error-500-internal-server-error">
  API Error: 500 Internal server error
</h3>

Claude Code は、5xx レスポンスに対して、ステータスコードと API のエラーメッセージを表示します。以下の例は、Anthropic API での 500 レスポンスを示しています。

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は、サービスの健全性を確認する場所を示し、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry の設定は、そのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

API 自体から返される 5xx は、API 内部の予期しない障害を示しています。これはプロンプト、設定、またはアカウントが原因ではありません。

プロキシ、ロードバランサー、またはゲートウェイが HTML エラーページで応答する場合、メッセージはステータスコードとページのタイトル（`API Error: 502 Bad Gateway` など）を表示します。タイトルのないページの場合、メッセージはステータスコードとその標準名を代わりに表示します。v2.1.281 より前では、ページにタイトルがある場合はステータスコードが削除され、タイトルがない場合はページの生のマークアップが出力されていました。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、アクティブなインシデントを確認してください
* 1 分待ってから、メッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は、全体を貼り付ける代わりに `try again` と入力できます。
* エラーが投稿されたインシデントなしで続く場合は、`/feedback` を実行して、Anthropic がリクエストの詳細で調査できるようにしてください。環境で `/feedback` が利用できない場合は、[Report an error](#report-an-error) を参照してください。

<h3 id="api-error-repeated-529-overloaded-errors">
  API Error: Repeated 529 Overloaded errors
</h3>

API は全ユーザー間で一時的に容量に達しています。Claude Code はこのメッセージを表示する前に既に数回再試行しています。

```text theme={null}
API Error: Repeated 529 Overloaded errors. The API is at capacity — this is usually temporary. Try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は、上記の 500 エラーと同じ方法でプロバイダーによって異なります。

529 は使用制限ではなく、クォータにもカウントされません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、容量に関する通知を確認してください
* 数分後に再度試してください
* `/model` を実行して別のモデルに切り替えて、作業を続けてください。容量はモデルごとに追跡されるためです。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、これを行うよう促します。例えば `Opus is experiencing high load, please use /model to switch to Sonnet` のようなメッセージが表示されます。Fable モデルでは、メッセージは Fable を示します。

  Claude Desktop アプリが実行するセッション（Code タブや Cowork など）では、メッセージは `Opus is experiencing high load. Switch to Sonnet.` と読まれ、アプリのモデルピッカーでモデルを切り替えます。

<h3 id="request-timed-out">
  Request timed out
</h3>

API は接続期限前に応答しませんでした。

```text theme={null}
Request timed out
```

これは高負荷期間中、またはモデルが非常に大きなレスポンスを生成しているときに発生する可能性があります。デフォルトのリクエストタイムアウトは 10 分です。

**対応方法：**

* リクエストを再試行してください
* 遅いネットワークまたはプロキシが原因の場合は、[Automatic retries](#automatic-retries) で説明されているように `API_TIMEOUT_MS` を上げてください
* タイムアウトが頻繁で、ネットワークが正常な場合は、以下の [Network and connection errors](#network-and-connection-errors) を参照してください

<h3 id="no-response-from-api">
  No response from API
</h3>

Claude Code はストリーミングリクエストを送信し、API は最初のバイトの期限内に応答ヘッダーを返さなかったため、Claude Code は完全な `API_TIMEOUT_MS` リクエストタイムアウト（デフォルトは 10 分）を待つ代わりにリクエストを中止しました。Claude Code は [retry budget](#tune-retry-behavior) が許可する場合、最大 1 回リクエストを再度送信します。再試行も応答がない場合、ターンはこのメッセージで終了し、各試行が待機した時間を示します。[`CLAUDE_CODE_RETRY_WATCHDOG`](/docs/ja/env-vars) を設定すると、1 回の再試行の上限は適用されず、Claude Code は [Tune retry behavior](#tune-retry-behavior) で説明されているバジェット下で再試行します。

```text theme={null}
API Error: No response from API (waited 3m, then 10m on the retry). If a proxy or gateway on your network holds responses until they complete, raise API_TIMEOUT_MS or CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS to wait longer.
```

Claude Code は最初の試行の応答ヘッダーの待機と再試行の待機を個別に設定します。

* **最初の試行**: [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](/docs/ja/env-vars) を 1 以上に設定した場合、10 秒から 30 分の間にクランプされます。それ以外の場合、Claude Code は [Streaming idle watchdogs](/docs/ja/network-config#streaming-idle-watchdogs) に記載されているバイトレベルのウォッチドッグタイムアウトを使用するため、そのタイムアウトを変更する変数はこの待機も変更します。どちらの場合でも、Claude Code はリクエストボディの 32KB ごとに 1 秒を追加します。
* **再試行**: `API_TIMEOUT_MS` より 1 秒少ない、デフォルトではほぼ 10 分。これにより、再試行は応答を生成完了まで保持するプロキシまたはゲートウェイを上回ることができます。Amazon Bedrock では、再試行は最初の試行と同じ期限を使用し、メッセージは 2 つの期間ではなく 1 つの期間を示します。

どちらの待機も、正の `API_TIMEOUT_MS` より 1 秒少ない値を超えず、11 秒未満の正の `API_TIMEOUT_MS` は期限をオフにします。バイトレベルのウォッチドッグは応答ヘッダーが到着した後にのみ開始されるため、その後バイト送信を停止するレスポンスは、この期限ではなく [stalled-stream rules](#automatic-retries) に従います。

**対応方法：**

* メッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は、全体を貼り付ける代わりに `try again` と入力できます。
* 繰り返される場合は、[ネットワークまたはプロキシの問題](#unable-to-connect-to-api) として扱ってください。
* ネットワーク上のプロキシまたはゲートウェイが応答を生成完了まで保持する場合は、`API_TIMEOUT_MS` を上げて再試行がより長く待機するようにしてください。Amazon Bedrock では、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` も上げてください。
* 最初の試行がタイムアウトし続け、再試行が成功する場合は、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` を上げて最初の試行も十分に長く待機するようにしてください。

v2.1.242 より前では、Claude Code は応答のないストリーミングリクエストが失敗する前に、完全な `API_TIMEOUT_MS` リクエストタイムアウト（デフォルトは 10 分）を待機していました。v2.1.261 より前では、再試行は最初の試行と同じ期限を待機し、メッセージは期間を示していませんでした。

<h3 id="the-response-above-may-be-incomplete">
  The response above may be incomplete
</h3>

ストリーミングリクエストがレスポンスの進行中に失敗しました。Claude がテキストのブロックまたはツール呼び出しを完了した後、または思考を終了した後に 1 つを開始した後です。リクエストを再送信すると、同じツール呼び出しが 2 回実行される可能性があるため、Claude Code は Claude が完了した出力を保持し、ターンを破棄する代わりにこの通知を追加します。表示されるバリアントは原因を示します。

```text theme={null}
API Error: Server error mid-response. The response above may be incomplete.
API Error: Connection lost mid-response. The response above may be incomplete.
API Error: Your computer went to sleep mid-response. The response above may be incomplete.
API Error: The response stopped arriving. The response above may be incomplete.
API Error: Part of the response never arrived. The response above may be incomplete.
API Error: The response stream was malformed. The response above may be incomplete.
```

* `Server error mid-response`: ストリーム中のオーバーロードまたは 5xx サーバーエラー。このバリアントには Claude Code v2.1.199 以降が必要です。それ以前は、その場合は部分的な出力を破棄し、ターン全体をエラーとして報告していました。
* `Connection lost mid-response`: 接続が切断されました。プロキシまたはゲートウェイがレスポンスボディをレスポンスが完了する前にクリーンに終了する場合にも、このバリアントが表示されます。
* `Your computer went to sleep mid-response`: Claude Code は、レスポンスがストリーミング中にコンピューターがスリープ状態になったことを検出しました。コンピューターが起動すると、Claude Code は接続を破損として扱い、読み取りを停止します。
* `Part of the response never arrived`: ストリームイベントが API と Claude Code の間でドロップされたため、後のイベントが到着しなかったコンテンツを参照していました。v2.1.281 より前では、このケースは `API Error: Content block not found` でターンを終了していました。
* `The response stream was malformed`: 既に完了していたコンテンツブロックのイベントが到着しました。または、イベントが破損した状態で到着しました。破損したイベントとは、データが有効な JSON ではない、コンテンツが欠落している、またはコンテンツがイベントのタイプと一致しないイベントです。v2.1.284 より前では、Claude が思考、テキストのブロック、またはツール呼び出しを完了した後に無効な JSON を持つイベントが到着した場合、パーサーの生のエラー（`API Error: JSON Parse error` で始まるものなど）が代わりに表示されていました。
* `The response stopped arriving`: 接続は開いたままでしたが、データの配信を停止したため、ストリーミングアイドルウォッチドッグがそれを中止しました。v2.1.222 より前では、Claude Code は `ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` を通じて到達する [ゲートウェイ](/docs/ja/gateways) 接続で、サーバーのキープアライブピングがまだ到着している間にもこの障害を報告することがありました。これは、そこでは解析された応答イベントのみをカウントしていたためです。アップグレードすると、これらのルートでの誤ったタイムアウトが発生しなくなります。`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーベース URL を通じて到達するゲートウェイは、バイトウォッチドッグでラップされていません。[Streaming idle watchdogs](/docs/ja/network-config#streaming-idle-watchdogs) を参照してください。

v2.1.227 より前では、`Connection lost mid-response` は `Connection closed mid-response` と読まれ、`The response stopped arriving` は `Response stalled mid-stream` と読まれていました。

Claude がテキストまたはツール呼び出しを開始する前にドロップ、重複、または破損したストリームイベントが到着した場合、この通知は表示されません。

* Claude が思考のみを完了していた場合、Claude Code はリクエストを再発行します。再発行されたストリームが同じ方法で破損する場合、ターンは `Part of the response never arrived and no response was produced. Try again.` または `The response stream was malformed and no response was produced. Try again.` で終了します。
* 何も完了していない場合、Claude Code はストリーミングなしでリクエストを再送信します。[`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK`](/docs/ja/env-vars) でそのフォールバックをオフにした場合、ターンはドロップされたイベントの場合は `API Error: Content block not found` で、または重複したイベントの場合は `API Error: Content block already closed` で終了します。破損したイベントでフォールバックがオフの場合、ターンは `API Error: Stream event unreadable` またはパーサーの生のエラーで終了します。

4 つのケースでは、Claude Code はこの通知をすぐに表示せずに障害を処理します。

* レスポンスの前半で、Claude Code は障害を再試行するか、別のエラーでターンを終了します。[Automatic retries](#automatic-retries) を参照してください。
* これらの障害の 1 つが Claude がレスポンスを完了した後に到着した場合、Claude Code は完全なレスポンスを保持し、この通知なしでターンを正常に終了します。v2.1.222 より前では、Claude Code はレスポンスが完了した後に接続が切断またはストールした場合、この通知を表示し、レスポンスが完全であったにもかかわらずターンをエラーとして報告していました。
* [非対話セッション](/docs/ja/headless)（`-p` 実行、[Agent SDK](/docs/ja/agent-sdk/overview) 実行、または [クラウドセッション](/docs/ja/claude-code-on-the-web) など）では、途中で切れたレスポンスがメイン会話にあり、テキストを含むがツール呼び出しを含まない場合、`continue` を自分で送信する必要はありません。Claude Code は部分的な出力を保持し、Claude に停止した場所から続行するよう促します（最大 3 回連続）。この通知は、Claude Code がこれらの継続を使い果たした後にのみ、そのようなレスポンスに対して表示されます。v2.1.246 より前では、Claude Code は最初の途切れでこの通知とともに非対話ターンを終了していました。
* [サブエージェント](/docs/ja/sub-agents#api-errors-in-subagents)では（セッションが対話かどうかに関わらず）、途中で切れたレスポンスがテキストを含むがツール呼び出しを含まない場合、Claude Code はサブエージェントに続行するよう促します。通知は、これらの継続が使い果たされた後にのみ、サブエージェントの最後のメッセージになります。v2.1.257 より前では、サブエージェントは最初の途切れでこの通知を表示していました。

**対応方法：**

* 対話セッションでは、画面に残っているレスポンスを読んでください。Claude Code はエラーの前に Claude が完了したすべてのブロックを保持しますが、ターンが終了するときに中断された最終ブロックを破棄するため、最終文またはツール呼び出しが欠落している可能性があります。`continue` で返信して、Claude が最後に完了したブロックから再開するようにしてください。
* [非対話モード](/docs/ja/headless)（`-p`）では：
  * デフォルトのテキスト出力では、Claude Code は、ターンの前半から保持している最後に完了したテキストのブロックを出力し、その後このメッセージを出力します。何も保持していない場合、Claude Code はこのメッセージのみを出力します。例えば、Claude Code がターン中に会話をコンパクト化し、そのテキストをクリアした場合です。v2.1.219 より前では、Claude Code は `-p` テキスト出力でこのメッセージのみを出力し、既に生成されたレスポンスを削除していました。
  * `--output-format json` または `stream-json` では、Claude Code はこのメッセージを `result` フィールドで報告します。
  * 接続が安定したら、ターンを続行するために、セッションを再開し、[Continue conversations](/docs/ja/headless#continue-conversations) で説明されているように `continue` を送信してください。

<h3 id="auto-mode-cannot-determine-the-safety-of-an-action">
  Auto mode cannot determine the safety of an action
</h3>

[auto モード](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) がアクションを分類するために使用するモデルが決定を生成できなかったため、auto モードはアクションを自動的に承認しませんでした。表示されるメッセージは、分類器が失敗した方法によって異なります。

作業ディレクトリ内の読み取り、検索、編集は分類器をスキップするため、これらすべてのケースで動作し続けます。

分類器モデルが利用できない場合：

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait a moment and then try this action again.
```

Claude Code が障害カテゴリを判定できる場合、`temporarily unavailable` の後の括弧内にカテゴリを示します。例えば `<model> is temporarily unavailable (rate-limited), so auto mode cannot determine the safety of <tool> right now`。カテゴリは `(rate-limited)`、`(overloaded)`、`(server error)`、`(timed out)`、`(connection failed)` です。`(timed out)` または `(connection failed)` が繰り返される場合は、接続を確認してください。[Unable to connect to API](#unable-to-connect-to-api) を参照してください。v2.1.229 より前では、メッセージはカテゴリを示さず、`Wait briefly and then try this action again` と読まれていました。

カテゴリが適合しない場合、メッセージは括弧内にカテゴリなしで表示されます。複数の障害がその形式を生成します。[Amazon Bedrock](/docs/ja/amazon-bedrock)（[Mantle endpoint](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) を含む）では、AWS アカウントがメッセージに示されているモデルを呼び出せない場合にも表示され、その障害はアカウントにモデルへのアクセスが付与されるまで、すべての再試行で繰り返されます。

**対応方法：**

* 数秒後に再試行してください。Claude は同じメッセージを見て、通常は自動的に再試行します。一時的な障害は [auto モードの利用資格](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) とは無関係です。設定を変更する必要はありません
* 再試行が失敗し続ける場合は、読み取り専用タスクを続行し、後でブロックされたアクションに戻ってください
* Amazon Bedrock では、メッセージがすべての再試行で返される場合は、アカウントがそれが示すモデルを呼び出せることを確認してください。標準の Amazon Bedrock モデルの場合、[IAM policy](/docs/ja/amazon-bedrock#iam-configuration) がそれを呼び出すことを許可していることを確認してください。Mantle モデル ID の場合は、[AWS アカウントチームに連絡してください](/docs/ja/amazon-bedrock#mantle-endpoint-errors)

OAuth トークンの有効期限が切れたか、別のセッションによってローテーションされたために分類器リクエストが失敗した場合、Claude Code はトークンをリフレッシュし、リクエストを 1 回再試行するため、日常的なトークンの有効期限切れはこのメッセージとして表示されません。v2.1.216 より前では、有効期限が切れたまたはローテーションされたトークンによってすべての分類器リクエストが失敗し、トークンがリフレッシュされるまで auto モードはこのメッセージで確認対象のすべてのアクションを拒否していました。

分類器が解析不可能なレスポンスを返した場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**対応方法：**

* アクションを再試行してください。これは通常、次の試行で成功します
* `claude --debug` を実行し、アクションを繰り返して、デバッグログで詳細を確認してください

別の API セーフティチェックが、以前の会話コンテンツのために分類器リクエストをブロックした場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — a safety check separate from auto mode blocked this request because of earlier conversation content — it isn't about the action itself — run with --debug for details
```

Claude Code はアクションを拒否しますが、Claude にこれはアクションが安全でないという判断ではなく、再試行するのではなく他のタスクを続行するよう伝えます。これらの拒否は [auto モードの一時停止しきい値](/docs/ja/permission-modes#when-auto-mode-falls-back) にカウントされません。[非対話](/docs/ja/headless) `-p` 実行では、Claude Code は実行を停止しません。Claude が受け取るものは、アクションを要求した場所によって異なります。

* `--input-format stream-json` なしの `-p` 実行における [バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) に対しては、Claude Code は `Agent aborted: auto mode classifier request refused by the safety safeguard in headless mode` を含むエラー結果を返します
* 対話セッションと `-p` 実行のメイン会話を含む、その他すべての場所では、Claude Code はその拒否を Claude に返します

v2.1.225 より前では、Claude Code はこれらの拒否を一時停止しきい値にカウントし、本物の分類器ブロックと同じ拒否メッセージを返していました。

**対応方法：**

* これはアクションに関する決定ではありません。会話に既にあるコンテンツが、auto モードが分類器に会話を送信したときに API のセーフティフィルターをトリガーしました
* 再試行は役に立ちません。同じ会話コンテンツがフィルターを再度トリガーします
* 対話セッションでは、別の [権限モード](/docs/ja/permission-modes) に切り替えて、プロンプトが表示されたときにアクションを承認できるようにしてください
* トリガーするコンテンツなしで新しい会話を開始してください

会話が分類器のコンテキストウィンドウより大きくなった場合：

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

アクションに何が起こるかは、Claude がそれを要求した場所によって異なります。

* 対話セッションでは、auto モードはそのアクションに対して通常の権限プロンプトにフォールバックするため、手動で承認または拒否できます
* `--input-format stream-json` なしの [非対話](/docs/ja/headless) `-p` 実行における [バックグラウンドサブエージェント](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) に対しては、Claude Code は `Agent aborted: auto mode classifier transcript exceeded context window in headless mode` を含むエラー結果を返し、実行は続行されます
* [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) なしの `-p` 実行の他の場所では、フォールバックするプロンプトがないため、アクションは実行されず、実行は続行されます

**対応方法：**

* 対話セッションでは、表示されるプロンプトでアクションを承認または拒否してください
* 対話セッションでは、`/compact` を実行して会話サイズを削減し、後続のアクションが分類器ウィンドウ内に再び収まるようにしてください

<h3 id="the-server-returned-no-safety-verdict">
  The server returned no safety verdict
</h3>

[サーバー側の分類器レビュー](/docs/ja/permission-modes#server-side-classifier-review) では、auto モードはサーバーがアクションに対して判定を返さないときにそのアクションを拒否します。拒否は、Claude Code が判定できる場合、括弧内にカテゴリ（`(timed out)` など）を示します。

```text theme={null}
The server-side auto mode classifier gave no verdict (timed out), so auto mode cannot determine the safety of <tool>.
```

メッセージの残りの部分は、1 回の再試行が役に立つかどうかを Claude に伝えます。これらの拒否の一部では、Claude の次の試行がすぐに続かないように、Claude Code は事前に待機します。対話セッションでの待機中、スピナーは `Auto mode check unavailable` とカウントダウンを表示し、`Esc` を押すとターンが中断されます。

10 回連続で判定のないレスポンスが続くと、auto モードはターンを停止します。

```text theme={null}
Auto mode is unavailable — the server returned no safety verdict for the last 10 responses, so Claude stopped. Send a message to try again, or switch out of auto mode.
```

停止メッセージは、セッションの種類ごとに異なる場所に表示されます。

* 対話セッションでは、メッセージはトランスクリプトに警告として表示され、ターンが終了します
* [非対話](/docs/ja/headless) `-p` 実行では、実行が終了し、実行エラーを報告します。デフォルトのテキスト出力では、メッセージは stderr に出力されます。
* [サブエージェント](/docs/ja/sub-agents) が制限に達した場合、サブエージェントは完了する前に停止し、Claude は auto モードがそれを停止したことを示すメモ付きで、それまでに生成されたものを受け取ります

**対応方法：**

* 別のメッセージを送信して、Claude が再度試行するようにしてください。レスポンスのカウントはリセットされます。
* 停止が繰り返され、リクエストが [LLM ゲートウェイまたはプロキシ](/docs/ja/llm-gateway) を経由する場合は、それがストリーミングレスポンスを途中で切り詰めたり書き換えたりしていないかを確認してください。[サーバー側の分類器レビュー](/docs/ja/permission-modes#server-side-classifier-review) にはどのゲートウェイの動作が拒否を引き起こすかが記載され、[ゲートウェイ互換性ガイド](/docs/ja/llm-gateway-protocol#feature-pass-through) には変更せずにそのまま渡すべきものが記載されています。
* Claude Code を開始する前に `CLAUDE_CODE_AUTO_MODE_SERVER=0` を設定して、代わりに Claude Code 独自の分類器リクエストを使用してください。v2.1.281 より前では、Claude Code は Anthropic API への直接接続でこの変数を読み取りませんでした。
* 代わりにアクションを自分で承認するには、[auto モードから切り替えてください](/docs/ja/permission-modes#switch-permission-modes)

v2.1.280 より前では、Claude Code は判定のないレスポンスからの各アクションを直ちに拒否し、ターンを停止することはありませんでした。

<h3 id="agent-terminated-early-due-to-an-api-error">
  Agent terminated early due to an API error
</h3>

[サブエージェント](/docs/ja/sub-agents) の API リクエストが回復不能な形で失敗しました。例えば、使用制限に達したか、サーバーエラーの再試行を使い果たしたため、サブエージェントはタスクを完了する前に停止しました。このメッセージには Claude Code v2.1.199 以降が必要です。それ以前は、API エラーテキストはサブエージェントの結果であるかのように Claude に返されていました。

```text theme={null}
Agent terminated early due to an API error: <error detail>
```

**対応方法：**

* コロンの後のエラー詳細を、このページの該当するセクション（[Usage limits](#usage-limits) や [Server errors](#server-errors) など）と照合し、そのセクションの手順に従ってください
* 根本のエラーが解消されたら、Claude にタスクを再試行するか、[サブエージェントを再開する](/docs/ja/sub-agents#resume-subagents) よう依頼してください

レート制限、オーバーロード、またはサーバーエラーが、既にテキスト出力を生成したフォアグラウンドサブエージェントを中断した場合、Claude はこのエラーの代わりに、不完全としてマークされたその部分的な出力を受け取ります。出力がツール呼び出しのみだったサブエージェントもこのエラーを受け取ります。v2.1.199 では、その形の出力は代わりに空の部分的な結果を返していました。[API errors in subagents](/docs/ja/sub-agents#api-errors-in-subagents) を参照してください。

<h2 id="usage-limits">
  使用制限
</h2>

このセクションのほとんどのエラーは、アカウントまたはプランに関連付けられたクォータに達したことを意味します。3 つのエラーは異なる動作をします。[`Server is temporarily limiting requests`](#server-is-temporarily-limiting-requests) はプランクォータとは無関係なサーバー側のスロットル、[`Usage credits required for 1M context`](#usage-credits-required-for-1m-context) は使い果たされたクォータではなく権利確認、[`The prompt to confirm went unanswered`](#the-prompt-to-confirm-went-unanswered) は使用クレジット同意プロンプトが未回答で閉じられたことを意味し、クォータに達したかどうかは関係ありません。

<h3 id="youve-hit-your-session-limit">
  セッション制限に達しました
</h3>

サブスクリプションプランには、ローリング使用許容量が含まれています。それが尽きると、次のいずれかのメッセージが表示されます。

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
You've hit your Sonnet limit · resets 3:45pm
```

Claude Code はメッセージに表示されたリセット時刻まで、それ以上のリクエストをブロックします。セッション制限と週間制限はすべてのモデル間で共有されるため、モデルを切り替えてもアクセスは復元されません。Opus 制限と Sonnet 制限はそれぞれそのモデルファミリーへのリクエストにのみ適用されるため、`/model` で別のファミリーのモデルに切り替えると、作業を続行できます。

claude.ai サブスクリプションでサインインしたインタラクティブセッションでは、Claude Code はオープンセッションで待機し、リセット直後に中断されたタスクを続行することもできます。[使用制限がリセットされるのを待つ](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset) を参照して、表示内容、待機の開始またはキャンセル方法、自動続行をオフにする方法を確認してください。v2.1.234 より前では、Claude Code はこの待機機能を提供していませんでした。

使用量はセッション許容量と週間許容量に同時にカウントされます。大規模なワークフロー展開など、単一の大量アクティビティのバースト、セッションウィンドウがリセットされる前に週間許容量を使い果たす可能性があります。

**対応方法：**

* エラーに表示されたリセット時刻まで待機します
* [Desktop アプリ](/docs/ja/desktop) の Code タブでは、セッション制限カードに **Auto-continue when limits reset** チェックボックスが表示されます。週間制限カードには表示されません。チェックされている場合、Desktop アプリはリセット後に中断されたターンを再試行し、カードに再試行時刻を表示します。Desktop チェックボックスと CLI の `/config` の **Continue automatically at usage limit** 設定は別個なので、それぞれ個別にオフにしてください。
* Opus または Sonnet 制限の場合、`/model` を実行してそのファミリー外のモデルに切り替えて、作業を続行します。各モデルは独自のプロンプトキャッシュを持つため、次のリクエストは会話全体を再度読み込み、キャッシュヒットはありません。[モデルの切り替え](/docs/ja/prompt-caching#switching-models) を参照してください
* `/usage` を実行して、プラン制限とリセット時刻を確認します
* `/usage-credits` を実行して、Pro と Max で追加使用量を購入するか、Team と Enterprise で管理者にリクエストします。[有料プランの使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) を参照して、これがどのように請求されるかを確認してください。
* プランをアップグレードしてベース制限を高くするには、[claude.com/pricing](https://claude.com/pricing) を参照してください

ウィンドウが終了する前に、Claude Code はほとんどを使用したことを警告できます。例えば `You've used 85% of your session limit · resets 3:45pm` というメッセージが表示されます。残りの許容量を継続的に監視するには、`rate_limits` フィールドを [カスタムステータス行](/docs/ja/statusline#rate-limit-usage) に追加するか、Desktop アプリでモデルピッカーの横にある [使用量リング](/docs/ja/desktop#check-usage) をクリックします。

<h3 id="usage-credits-required-for-1m-context">
  1M コンテキストに使用クレジットが必要です
</h3>

選択されたモデルは 1M トークン拡張コンテキストウィンドウを使用しており、プランはそれを使用クレジットを通じてのみ含みます。

```text theme={null}
API Error: Usage credits required for 1M context · run /usage-credits to turn them on (they take effect after you restart Claude Code), or /model to switch to standard context
```

Claude Desktop アプリが実行するセッションでは、ヒントはコマンドを指定しません。claude.ai 使用設定ページを指し、Team と Enterprise プランでは claude.ai/admin-settings/usage で使用クレジットをオンにするか、管理者に依頼するよう指示します。

これはクォータ枯渇ではなく、権利確認です。セッション許容量と週間許容量に容量が残っている場合でも発火します。[拡張コンテキスト](/docs/ja/model-config#extended-context) を参照して、どのプランが 1M コンテキストを直接含み、どのプランが使用クレジットを必要とするかを確認してください。

このエラーが会話の途中でコンテキストが 200K トークンを超えて成長したために表示される場合、Claude Code は自動的に会話を標準コンテキスト制限の下に圧縮し、その後セッションをその制限に保つため、アクションは不要です。v2.1.172 より前のバージョンでは、エラーは `/compact` を含むその後のすべてのリクエストで繰り返されました。これらのバージョンで復旧するには `/clear` を実行してください。以下の手順は、明示的に `[1m]` モデルを選択した場合に適用されます。

**対応方法：**

* `/model` を実行し、`[1m]` サフィックスなしのバリアントを選択して、標準コンテキストウィンドウにフォールバックします
* メッセージが `/usage-credits` を指定する場合、それを実行して Pro と Max で 1M バリアントのメータリング課金をオンにするか、Team と Enterprise で管理者に使用クレジットをリクエストします。使用クレジットがオンになったら Claude Code を再起動するか、新しいセッションを開始します。メッセージが指定するまで、セッションは標準コンテキスト制限に留まります。
* `/model` の後もエラーが続く場合、1M モデル ID が他の場所に設定されている可能性があります。[モデルの設定](/docs/ja/model-config#setting-your-model) を参照して、優先順位順に確認する設定場所を確認してください。
* モデルピッカーから 1M バリアントを完全に削除するには、[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/docs/ja/env-vars) を設定します

v2.1.268 より前では、メッセージは `run /usage-credits to turn them on, or /model to switch to standard context` で終わり、再起動について言及していませんでした。

<h3 id="the-prompt-to-confirm-went-unanswered">
  確認プロンプトが未回答のまま終了しました
</h3>

アカウントが [Fable 使用クレジット同意](/docs/ja/model-config#fable-and-usage-credits) を必要とする場合、Claude Code は Fable リクエストが使用クレジットを請求する前に確認するよう求めます。同意プロンプトが誰も答えないまま閉じられた場合、Claude Code はターンを次のいずれかのメッセージで終了します。

```text theme={null}
Fable limit reached · continuing on Fable 5.1 uses usage credits, and the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
Fable 5.1 now uses usage credits · the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
```

メッセージはセッションの Fable モデルを指定するため、Fable 5 では `continuing on Fable 5` と `Fable 5 now uses usage credits` と表示されます。v2.1.257 より前では、最初のメッセージは `Fable 5 limit reached` で始まりました。

これは [Remote Control](/docs/ja/remote-control) セッション、[バックグラウンドセッション](/docs/ja/agent-view)、[エージェントチーム](/docs/ja/agent-teams) チームメイトセッション、および Agent SDK を通じてホストする別のアプリケーションで発生します。Claude Code がプロンプトを閉じるタイミングについては、[Fable と使用クレジット](/docs/ja/model-config#fable-and-usage-credits) を参照してください。

**対応方法：**

* セッションが実行されるターミナルまたはそれをホストするアプリケーションで、別のプロンプトを送信し、再度表示されたら同意プロンプトに答えます。バックグラウンドセッションの場合、最初に [エージェントビュー](/docs/ja/agent-view) からアタッチします。Remote Control クライアントから再送信すると、クライアントがプロンプトを表示できないため、このメッセージが再度表示されます。
* `/model` を実行して、使用クレジットを請求しないモデルに切り替えます
* より多くの時間を確保するには、[`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) をより長い値または `"never"` に設定します

v2.1.236 より前では、このメッセージは表示されませんでした。Remote Control クライアントが接続されている間、Claude Code は回答を 60 秒待ってからデフォルトモデルでターンを続行しました。

<h3 id="server-is-temporarily-limiting-requests">
  サーバーが一時的にリクエストを制限しています
</h3>

API は、プランクォータとは無関係の短期的なスロットルを適用しました。

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

Claude Code は、実際の制限応答が持つ統一クォータヘッダーの不在によって、これらをプラン制限と区別します。v2.1.199 以降、これは認証方法に関係なく、[自動的に再試行](#automatic-retries) されてからバックオフで表示されます。以前のバージョンでは、claude.ai サブスクリプションでサインインしたセッションは最初の発生時にターンに失敗しました。API キーと Enterprise サインインのみが再試行しました。

**対応方法：**

* 少し待ってから再度試してください
* 続く場合は [status.claude.com](https://status.claude.com) を確認してください

<h3 id="request-rejected-429">
  リクエストが拒否されました（429）
</h3>

API キー、Amazon Bedrock プロジェクト、または Google Cloud プロジェクト用に設定されたレート制限に達しました。

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

末尾の文はサービスヘルスを確認する場所を指定し、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry 設定は、Anthropic ステータスページの代わりにそのプロバイダーのサービスステータスを指定します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを指定します。

Claude Code と API の間のプロキシ、ロードバランサー、またはゲートウェイが独自の HTML 429 ページで応答する場合、`·` の後のテキストはそのページのタイトル（存在する場合）です。例えば `Too Many Requests` など。v2.1.281 より前では、ページ全体のマークアップが `·` の後に出力されていました。

**対応方法：**

* `/status` を実行して、アクティブな認証情報が予想されるものであることを確認します。環境内の迷走した `ANTHROPIC_API_KEY` は、サブスクリプションの代わりに低層キーを通じてリクエストをルーティングできます。
* プロバイダーコンソールでアクティブな制限を確認し、必要に応じてより高い層をリクエストします
* Anthropic API キーについては、[レート制限リファレンス](https://platform.claude.com/docs/en/api/rate-limits) を参照して、層がどのように機能し、ワークスペースごとのキャップを設定する方法を確認してください
* 同時実行性を削減します。[`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/docs/ja/env-vars) を低くするか、多くの並列サブエージェントの実行を避けるか、高ボリュームのスクリプト実行用に `/model` で小さいモデルに切り替えます

<h3 id="youve-hit-your-monthly-spend-limit">
  月間支出制限に達しました
</h3>

プランに含まれる使用量ではこのリクエストをカバーできず、それ以外の場合はそれを支払う [使用クレジット](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) が支出制限に達しました。これは、プランの使用ウィンドウの 1 つが尽きたとき、またはリクエストが使用クレジットのみが支払うもの（例えば [使用クレジットに請求](/docs/ja/model-config#fable-and-usage-credits) するモデルへのリクエスト）の場合に発生します。メッセージはどの制限があなたをブロックしたかを指定します。`·` の後のテキストはその制限を増やす方法を説明し、プランと請求を管理しているかどうかによって異なります。

```text theme={null}
You've hit your monthly spend limit · raise it at claude.ai/settings/usage
You've hit your individual spend limit · ask your admin for a higher limit
You've hit your org's monthly spend limit · visit claude.ai/admin-settings/usage to raise it
You've hit your team's shared budget · ask your admin to raise it at claude.ai/admin-settings/usage
You've hit your channel's monthly spend limit · an org owner or channel manager can raise it in the channel's Claude settings
```

`team's shared budget` はグループに割り当てられたプール予算で、メッセージはグループを指定しません。`channel's monthly spend limit` はセッションが実行される Slack チャネルの予算なので、組織は外部に予算を持つ可能性があります。

プランのウィンドウの 1 つが尽きたとき、メッセージはそのウィンドウがいつリセットされるかも言及します。例えば `· your session limit resets 3:45pm`、アクセスは誰も制限を上げることなく、その後に戻ります。使用量ベースの課金を持つ組織では、メッセージは `spend limit` の代わりに `usage limit` を言及します。例えば `You've hit your individual usage limit`。

v2.1.239 より前では、メッセージはプランウィンドウのリセット時刻を指定しませんでした。v2.1.268 より前では、グループのプール予算は `team's shared budget` の代わりに `individual spend limit` メッセージを生成しました。

Claude アプリゲートウェイを通じて接続し、小文字の `spend limit reached` を見る場合、それはゲートウェイオペレーターのキャップです。[支出制限に達しました](#spend-limit-reached) を参照してください。

**対応方法：**

* Pro と Max では、claude.ai の [**Settings > Usage**](https://claude.ai/settings/usage) で月間支出制限を増やすか、`/usage-credits` を実行します
* Team と Enterprise では、請求を管理する場合は [**Organization settings > Usage**](https://claude.ai/admin-settings/usage) で制限を増やすか、管理者に依頼します。`/usage-credits` は管理者にそのリクエストを送信します
* チャネルの制限については、組織の所有者またはチャネルのマネージャーに claude.ai で上げるよう依頼してください。Claude Tag ドキュメントの [Per-channel limits](https://claude.com/docs/claude-tag/admins/set-spend-limit#per-channel-limits) を参照してください
* メッセージがプランのウィンドウのリセット時刻を指定する場合、代わりにそれを待つことができます
* `/usage` を実行して、プランのウィンドウと各リセット時刻を確認します

<h3 id="spend-limit-reached">
  支出制限に達しました
</h3>

[Claude アプリゲートウェイ](/docs/ja/claude-apps-gateway) を通じて接続し、ゲートウェイオペレーターが設定した [支出キャップ](/docs/ja/claude-apps-gateway-spend-limits) を超えました。ゲートウェイは、指定された期間がリセットされるか、オペレーターがキャップを上げるまで、リクエストをブロックします。ブロックされた各 `429` レスポンスに `x-should-retry: false` をマークするため、Claude Code は再試行せずにこのメッセージを表示します。

```text theme={null}
spend limit reached (daily; resets 2026-08-09 00:00 UTC)
```

メッセージはキャップの期間とリセット時刻を指定し、オペレーターが `blocked_message` を設定した場合、その指示がそれに続きます。v2.1.225 より前では、メッセージは `spend limit reached` のみを読みました。古いバージョンのゲートウェイはまだその短い形式を送信します。

**対応方法：**

* メッセージが指定するリセット時刻まで待つか、メッセージがそれを含む場合はオペレーターの指示に従います
* ルーチンでそれに達する場合は、ゲートウェイオペレーターにキャップを上げるよう依頼します

関連するメッセージ `spend limit unavailable` は、ゲートウェイが支出レコードを読み取ることができず、キャップを超えるのではなく予防措置としてリクエストをブロックしたことを意味します。通常は自動的にクリアされます。続く場合は、ゲートウェイオペレーターに通知してください。

<h3 id="credit-balance-is-too-low">
  クレジット残高が低すぎます
</h3>

Console 組織がプリペイドクレジットを使い果たしたか、Claude Code が Console API キーでリクエストを送信しており、サブスクリプションを使用することを意図していました。

```text theme={null}
Credit balance is too low
```

**対応方法：**

* Pro、Max、Team、または Enterprise プランを持っており、これを見る場合は、`/status` を実行して `API key` 行を確認します。環境内の承認された `ANTHROPIC_API_KEY` は、サブスクリプションの代わりにそのキーを通じてリクエストをルーティングします。現在のシェルでそれを設定解除し、シェルプロファイルから削除してから、`claude` を再起動します。サブスクリプションでまだサインインしていない場合は `/login` を実行します。
* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing) でクレジットを追加し、そこで自動リロードを有効にして、残高がゼロに達する前に補充されるようにすることを検討してください
* Console でワークスペースごとの支出キャップを設定して、単一のプロジェクトが組織残高を消耗するのを防ぎます。[コストを効果的に管理](/docs/ja/costs) を参照してください。

<h3 id="could-not-update-your-spend-limit">
  支出制限を更新できませんでした
</h3>

サーバーは、支出制限に達したときに表示されるプロンプトから行った支出制限の変更を拒否しました。

```text theme={null}
Could not update your spend limit: <reason from the server>
```

サーバーが拒否を説明する場合、メッセージはその理由で終わり、同じ値を再試行すると再度失敗します。失敗に接続の切断など、サーバーが提供した理由がない場合、メッセージは `Could not update your spend limit. Press Enter to retry.` と表示され、再試行は成功する可能性があります。v2.1.216 より前では、Claude Code はすべての失敗に対して汎用形式を表示していました。

**対応方法：**

* メッセージに理由が含まれている場合は、より低い金額など、それを満たす制限を選択します
* メッセージが汎用形式のみを表示する場合は、再試行します。失敗は一時的である可能性があります
* 変更が失敗し続ける場合は、ブラウザの [claude.ai 請求設定](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) から代わりに行います

<h2 id="authentication-errors">
  認証エラー
</h2>

これらのエラーは、Claude Code が API に対してユーザーの身元を証明できないことを意味します。`/status` をいつでも実行して、現在どの認証情報が有効になっているかを確認できます。

<h3 id="not-logged-in">
  ログインしていません
</h3>

このセッションで使用できる有効な認証情報がありません。

```text theme={null}
Not logged in · Please run /login
```

Claude Desktop アプリが実行するセッション（Code タブや Cowork など）では、メッセージは `Authentication required · Sign in again to continue` となり、アプリから再度サインインします。

同じ[設定ディレクトリ](/docs/ja/claude-directory)を使用する別の Claude Code ウィンドウで claude.ai アカウントを使ってサインインすると、このメッセージを表示している対話セッションは自動的にそのログインを使い始めます。再起動する必要はありません。

macOS の v2.1.286 より前では、別のウィンドウからサインインした後もセッションがこのメッセージを表示し続けることがありました。それらのバージョンでは、メッセージを表示しているセッションを再起動してください。

**対処方法：**

* `/login` を実行して、Claude サブスクリプションまたは Console アカウントで認証します
* 環境変数で認証されることを想定していた場合は、`claude` を起動したシェルで `ANTHROPIC_API_KEY` が設定され、エクスポートされていることを確認します
* 対話的なログインができない CI や自動化では、起動時にキーを取得する [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトを設定します
* 複数の認証情報が存在する場合に Claude Code がどれを使用するかについては、[認証の優先順位](/docs/ja/authentication#authentication-precedence)を参照してください

繰り返しログインを求められる場合は、システムクロックの確認と macOS の認証情報ストレージの復旧手順について、[ログインしていない、またはトークンの有効期限切れ](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired)を参照してください。

<h3 id="could-not-resolve-authentication-method">
  認証方法を解決できませんでした
</h3>

セッションが認証情報なしで API クライアントに到達しました。[バックグラウンドセッション](/docs/ja/agent-view)とクラウドセッションでは、ワーカーが認証情報なしで起動したときにこのメッセージが表示されます。対話セッション、`-p`、Agent SDK の実行では、同じ状態を[ログインしていません](#not-logged-in)として報告し、この文字列はデバッグログにのみ書き込みます。そのため、デバッグログでこの文字列を見つけた場合は、代わりにその項目に従ってください。

```text theme={null}
Could not resolve authentication method. Expected one of apiKey, authToken, credentials, config, or profile to be set. Or for one of the "X-Api-Key" or "Authorization" headers to be explicitly omitted
```

現在のバージョンでは、このエラーはワーカープロセスで利用可能な認証情報がなかったことを意味します。v2.1.174 より前では、アイドル状態の事前初期化済みワーカーに割り当てられたバックグラウンドセッションが、有効な認証情報が設定されていてもこのように失敗することがありました。v2.1.176 より前では、割り当てられる前にアイドル状態だったクラウドセッションも同様に失敗することがありました。アップグレードすると復旧します。

**対処方法：**

* バックグラウンドセッションまたはクラウドセッションでこのエラーが表示され、認証情報がすでに設定されている場合は、v2.1.176 以降にアップグレードします
* `ANTHROPIC_API_KEY`、`CLAUDE_CODE_OAUTH_TOKEN`、またはクラウドプロバイダーの認証情報が、対話シェルだけでなく、ワーカーを起動する環境で設定されていることを確認します
* Agent SDK については、[クイックスタートの認証設定](/docs/ja/agent-sdk/quickstart#setup)を参照してください
* 同じ環境の対話セッションで `/status` を実行し、どの認証情報ソースが解決されるかを確認します

<h3 id="invalid-api-key">
  無効な API キー
</h3>

`ANTHROPIC_API_KEY` 環境変数または `apiKeyHelper` スクリプトが API に拒否されるキーを返したか、Claude Code が `ANTHROPIC_API_KEY` のキーを送信前にブロックしました。

```text theme={null}
Invalid API key · Fix external API key
```

メッセージで `Fix external API key` の後に `Invalid X-Api-Key header value from ANTHROPIC_API_KEY: it contains a line break at character 41 (120 characters on 2 lines).` のような説明が続く場合、API はキーを受け取っていません。Claude Code が HTTP ヘッダーで扱えない文字を検出し、送信前にリクエストを停止しました。説明の読み方と値の修正方法については、[無効なリクエストヘッダー値](#invalid-request-header-value)を参照してください。

**対処方法：**

* 入力ミスがないか確認し、[Console](https://platform.claude.com/settings/keys) でキーが取り消されていないことを確認します
* 同じシェルで `env | grep ANTHROPIC` を実行するか、PowerShell では `Get-ChildItem Env:ANTHROPIC*` を実行します。direnv、dotenv シェルプラグイン、IDE ターミナルなどのツールは、明示的に設定しなくても、プロジェクト内の `.env` ファイルから古いキーを読み込むことがあります。
* `ANTHROPIC_API_KEY` の設定を解除し、`/login` を実行して代わりにサブスクリプション認証を使用します
* キーが [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトから取得される場合は、スクリプトを直接実行して、有効なキーが stdout に出力されることを確認します
* `/status` を実行して、Claude Code が実際に使用している認証情報ソースを確認します

<h3 id="your-apikeyhelper-script-is-failing">
  apiKeyHelper スクリプトが失敗しています
</h3>

Claude Code は [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) 設定のコマンドを実行しましたが、キーを取得できませんでした。キーがない場合、リクエストはプレースホルダーの認証情報で API に到達し、API は `401` で拒否します。ターミナルの `Authentication` パネルに、次のどれが発生したかが表示されます。

* コマンドがエラーで終了したか、タイムアウトした
* コマンドが stdout に何も出力しなかった
* コマンドがキー以外のもの（ログインバナーやログ行など）を出力した。パネルには `returned output that cannot be used as an API key` と表示され、出力を繰り返すことなく何が問題かが示されます。v2.1.227 より前では、Claude Code はコマンドが出力したものを、前後の空白を取り除いたうえでそのまま送信していました。

```text theme={null}
Your apiKeyHelper script is failing · This usually means you need to re-authenticate with your provider · Run /status to see the script's error output
```

[非対話モード](/docs/ja/headless)では、stderr にも `apiKeyHelper failed:` という接頭辞付きで具体的な理由が出力されます。

Claude Code はこのメッセージを表示する前に、スクリプトを再実行してリクエストを最大 2 回まで再試行するため、失敗は 3 回以内の試行で表面化します。v2.1.208 より前では、Claude Code は[再試行の上限](#automatic-retries)をすべて使ってプレースホルダーの認証情報でリクエストを再送信し、その後スクリプトの失敗ではなく一般的な `401` 認証エラーを報告していました。

ここでは `/login` を実行しても解決しません。設定が存在する限り、ヘルパーの出力は保存済みのログインより[優先されます](/docs/ja/authentication#authentication-precedence)。

**対処方法：**

* `apiKeyHelper` に設定されたコマンドをシェルで直接実行して、失敗を再現します
* コマンドがセッションの有効期限切れを報告する場合は、認証情報プロバイダーで再認証します。たとえば、SSO やシークレットボールトに再度サインインします
* コマンドを修正して、キーのみを stdout に出力し（最大 16,384 文字の印字可能な ASCII からなる単一のトークンとして）、終了コード 0 で終了するようにします。動作する設定については、[apiKeyHelper で認証情報をローテーションする](/docs/ja/llm-gateway-connect#rotate-credentials-with-apikeyhelper)を参照してください。
* `/status` を実行して失敗を確認し、`apiKeyHelper` が有効な認証情報ソースであることを確認します。`apiKeyHelper` 行には `Failing` と、終了コードやコマンドのエラー出力など最後の失敗の詳細が表示され、次に実行が成功すると消えます。v2.1.274 より前では、`/status` には認証情報ソースのみが表示され、失敗は表示されませんでした。
* コマンドが失敗するたびに、その終了コードとエラー出力はターミナルの `Authentication` パネルにも表示されます。v2.1.212 より前では、パネルのタイトルは `Cloud authentication` でした。

<h3 id="invalid-request-header-value">
  無効なリクエストヘッダー値
</h3>

Claude Code がリクエストヘッダーとして送信しようとした値に、HTTP ヘッダーで扱えない文字（改行、NUL バイト、または曲線引用符やゼロ幅スペースなど `U+00FF` を超える文字）が含まれています。Claude Code は何かを送信する前にリクエストを停止し、修正すべき変数または設定の名前を示します。よくある原因は、ドキュメントやチャットから貼り付けた認証情報に、不可視の文字や余分な改行が含まれていたことです。

Claude Code は、Claude API に直接、または [LLM ゲートウェイ](/docs/ja/llm-gateway)経由でリクエストを送信するときにこのチェックを実行します。[Amazon Bedrock](/docs/ja/amazon-bedrock) などのサードパーティのクラウドプロバイダーでは、Claude Code は送信前にこのチェックを実行しません。

```text theme={null}
Invalid auth token · Fix external auth token
Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable
Invalid request header from the environment · Fix the environment variable
```

メッセージの最初の部分は、不正な値の出どころによって異なります。

* `Invalid auth token`：[`ANTHROPIC_AUTH_TOKEN`](/docs/ja/env-vars) または [`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars) からのベアラートークン
* `Invalid ANTHROPIC_CUSTOM_HEADERS`：[`ANTHROPIC_CUSTOM_HEADERS`](/docs/ja/env-vars) で設定したヘッダー名または値。説明では、名前や値を繰り返さずに、どの `Name: Value` ペアに問題があるかを `distinct header 2 of 3 parsed from ANTHROPIC_CUSTOM_HEADERS` のように番号で示します。名前と値はどちらもユーザー自身が選んだものだからです。
* `Invalid request header from the environment`：Claude Code が `CLAUDE_AGENT_SDK_CLIENT_APP` などの別の環境変数からリクエストヘッダーにコピーする値。説明には修正すべき変数の名前が示されます。

Claude Code は、このチェックで検出された不正な `ANTHROPIC_API_KEY` を、同じ末尾の説明付きで[無効な API キー](#invalid-api-key)として報告します。保存済みの `/login` 認証情報が不正な場合は、代わりに[ログインしていません](#not-logged-in)として報告します。`/login` を実行して新しい認証情報を保存してください。[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトの出力がこのチェックに到達することはありません。Claude Code はスクリプトの実行時に出力を検証し、HTTP ヘッダーで扱えない出力は[apiKeyHelper スクリプトが失敗しています](#your-apikeyhelper-script-is-failing)として失敗します。

2 つ目の `·` の後には、次の完全な例のように、問題の説明が続きます。

```text theme={null}
Invalid auth token · Fix external auth token · Invalid Authorization header value from ANTHROPIC_AUTH_TOKEN: it contains a line break at character 41 (120 characters on 2 lines).
```

位置は 1 から数えた文字数です。説明は固定のフレーズと文字数から構成されるため、値そのものが含まれることはありません。問題の文字の名前が示されるのは、バイトオーダーマーク、ゼロ幅スペース、曲線引用符など、よく知られた不可視文字または印刷用の文字である場合のみで、それ以外は `a non-ASCII character` として報告されます。

**対処方法：**

* メッセージが示す変数または設定を再設定します。同じソースから再度貼り付けるのではなく、報告された位置の周辺の文字を入力し直してください
* `ANTHROPIC_CUSTOM_HEADERS` では、1 行に 1 つの `Name: Value` ペアを記述し、メッセージが番号で示すペアを書き直します
* `/status` を実行して、有効な認証情報ソースを確認します

<h3 id="this-organization-has-been-disabled">
  この組織は無効化されています
</h3>

Claude Code が、無効化された Console 組織の古い `ANTHROPIC_API_KEY` を使用しています。保存済みのサブスクリプションログインがある場合、このキーがそれを上書きします。

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your subscription instead
Your ANTHROPIC_API_KEY belongs to a disabled organization · Update or unset the environment variable
API Error: 400 ... This organization has been disabled.
```

`·` の後のヒントは、保存済みの認証情報によって異なります。1 つ目の形式は、キーの設定を解除した後に保存済みの `/login` が引き継げる場合に表示され、2 つ目の形式はキーが唯一の認証情報である場合に表示されます。

環境変数は `/login` より優先されるため、シェルプロファイルでエクスポートされたキーや `.env` ファイルから読み込まれたキーは、有効な Pro または Max サブスクリプションがある場合でも使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。

**対処方法：**

* 現在のシェルで `ANTHROPIC_API_KEY` の設定を解除し、シェルプロファイルから削除してから、`claude` を再起動します
* メッセージに `Update or unset` と表示される場合、フォールバック先となる保存済みのログインはありません。キーの設定を解除して `/login` を実行するか、キーを有効な Console 組織のキーに置き換えます。
* その後 `/status` を実行して、有効な認証情報がサブスクリプションであることを確認します
* 環境変数が設定されていないのにエラーが解消しない場合は、サポートに問い合わせるか、別のアカウントでサインインしてください。

<h3 id="your-organization-has-disabled-api-key-authentication">
  組織で API キー認証が無効化されています
</h3>

このメッセージには Claude Code v2.1.169 以降が必要です。Console 組織の管理者が API キー認証をオフにしているため、API は Claude Code が送信しているキーを拒否します。`·` の後の復旧のヒントは、キーの出どころによって異なります。

```text theme={null}
Your organization has disabled API key authentication · Run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY to use your claude.ai account instead
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset the apiKeyHelper setting and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Sign in again with your claude.ai account
```

最後の形式は、Claude Desktop アプリが実行するセッション（Code タブや Cowork など）で表示されます。この場合はアプリから再度サインインします。

環境変数と `apiKeyHelper` は `/login` より優先されるため、いずれかがまだキーを提供している間は、`/login` を実行するだけでは解決しません。[認証の優先順位](/docs/ja/authentication#authentication-precedence)を参照してください。

**対処方法：**

* メッセージに `ANTHROPIC_API_KEY` が示されている場合は、現在のシェルで設定を解除し、シェルプロファイルまたは `.env` ファイルから削除してから、`claude` を再起動します
* メッセージに `apiKeyHelper` が示されている場合は、`settings.json` から [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) 設定を削除します
* `/login` を実行して claude.ai アカウントでサインインします
* その後 `/status` を実行して、有効な認証情報が API キーではなくサブスクリプションであることを確認します
* 自動化のために API キー認証が必要な場合は、組織の管理者に Console で再度有効にするよう依頼します

<h3 id="your-organization-has-disabled-claude-subscription-access">
  組織で Claude サブスクリプションアクセスが無効化されています
</h3>

Claude 組織では、サブスクリプションログインで Claude Code にサインインすることが許可されていません。同じアカウントで再度 `/login` を実行しても、同じエラーが返されます。

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

これはサーバー側の組織設定であるため、ローカル設定、環境変数、CLI フラグから上書きすることはできません。

Agent SDK と `-p` 非対話モードでは、これは `oauth_org_not_allowed` エラーコードとして表示されます。

**対処方法：**

* 組織で Claude Code へのアクセスを有効にするよう管理者に依頼します
* サブスクリプションではなく Console API キーで認証します。設定方法については、[Claude Console 認証](/docs/ja/authentication#claude-console-authentication)を参照してください。
* 管理者であってもアクセスを有効にするオプションが表示されない場合は、[Anthropic サポート](https://support.claude.com)に問い合わせてください

<h3 id="routines-are-disabled-by-your-organizations-policy">
  ルーティンが組織のポリシーにより無効化されています
</h3>

Team または Enterprise 組織の Owner が、組織レベルでルーティンをオフにしています。このエラーは、ルーティンを作成または実行しようとしたとき、たとえば claude.ai/code の [Routines](/docs/ja/routines) UI から操作したときに表示されます。Claude Code v2.1.227 以降では、同じ設定によって CLI の [`/schedule` も非表示になります](/docs/ja/routines#troubleshooting)。

```text theme={null}
Routines are disabled by your organization's policy.
```

これはサーバー側の設定であるため、ローカル設定、環境変数、CLI フラグから上書きすることはできません。

**対処方法：**

* 組織の Owner に、[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Routines** トグルを有効にするよう依頼します
* 組織レベルのルーティンを必要としない 1 回限りのスケジュール作業については、[スケジュールタスク](/docs/ja/scheduled-tasks)を参照してください

<h3 id="remote-control-requires-the-anthropic-api">
  Remote Control には Anthropic API が必要です
</h3>

セッションが Anthropic API と直接通信していませんが、[Remote Control](/docs/ja/remote-control) にはそれが必要です。

```text theme={null}
Remote Control is only available when using Claude via api.anthropic.com. CLAUDE_CODE_USE_BEDROCK is set, so this session is using Amazon Bedrock — unset it (or run in a shell without it) to use Remote Control.
```

2 文目では、セッションが Anthropic API 以外に向けられた原因を説明します。v2.1.219 より前では、メッセージは 1 文目のみでした。原因に応じて、メッセージには次のものが示されます。

* `CLAUDE_CODE_USE_*` プロバイダー変数（[Amazon Bedrock](/docs/ja/amazon-bedrock) の場合は `CLAUDE_CODE_USE_BEDROCK`、[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai) の場合は `CLAUDE_CODE_USE_VERTEX` など）
* `api.anthropic.com` 以外のホスト（[LLM ゲートウェイ](/docs/ja/llm-gateway)やプロキシなど）を指す [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars)。claude.ai でサインインしている場合も該当します。v2.1.196 より前では、カスタムのベース URL は Remote Control をブロックしませんでした
* 設定された `ANTHROPIC_UNIX_SOCKET`。この場合、セッションはリクエストを `api.anthropic.com` ではなくローカルソケット経由で送信します
* `/login` で行ったエンタープライズ向け[クラウドゲートウェイ](/docs/ja/claude-apps-gateway)へのサインイン。これは Remote Control をサポートしておらず、解除する変数もありません

**対処方法：**

* メッセージが示す変数（`CLAUDE_CODE_USE_BEDROCK` や `ANTHROPIC_BASE_URL` など）の設定を解除してセッションを再起動するか、Anthropic API と直接通信するセッションから Remote Control を開始します
* 変数がシェルで設定されていない場合は、[設定ファイル](/docs/ja/settings#where-settings-live)の `env` キーを確認します。このキーはすべてのセッションに環境変数を適用します
* このメッセージやその他の Remote Control 起動時のメッセージについては、[Remote Control のトラブルシューティング](/docs/ja/remote-control#troubleshooting)を参照してください

<h3 id="remote-control-couldnt-refresh-your-login">
  Remote Control がログインを更新できませんでした
</h3>

Claude Code は、保存済みの claude.ai ログインを使用して取得・更新する短期間有効な認証情報で、ライブの [Remote Control](/docs/ja/remote-control) 接続を実行します。claude.ai がそのログインを受け付けなくなった場合、または Claude Code に保存済みのログインが残っていない場合、Claude Code は Remote Control を停止し、再度サインインが必要になります。どちらの失敗も、Claude Code の接続中にも、その後の認証情報の更新時にも発生する可能性があります。

Claude Code がログインサービスに保存済みログインの更新を要求して応答が得られない場合、Remote Control を実行し続け、接続の現在の認証情報がまだ有効な間に更新を再試行します。Claude Code がログインサービスに到達できない場合、リクエストがタイムアウトした場合、またはサービスがログインを拒否せずに失敗した場合に、更新の応答が得られない状態になります。その認証情報の有効期限が切れた時点でもログインサービスが応答しない場合、Claude Code は Remote Control を停止し、`OAuth token refresh failed` を報告します。

Claude Code が Remote Control を停止すると、警告と、`Remote Control disconnected` で始まるトランスクリプトの行に理由が表示されます。ローカルセッションは Remote Control なしで実行され続けます。このセクションでは次の行を扱います。

```text theme={null}
Remote Control disconnected — Claude.ai login expired — run /login to restore Remote Control
Remote Control disconnected — Claude.ai login expired — run /login, then /remote-control
Remote Control disconnected — Claude.ai login was rejected — run /login, then /remote-control
Remote Control disconnected — OAuth token unavailable — run /login to restore Remote Control
Remote Control disconnected — OAuth token refresh failed — run /login to re-authenticate
Remote Control disconnected — JWT refresh failed: no OAuth token — run /login
Remote Control disconnected — Signed out of Claude — run /login, then /remote-control
```

Claude Code はメッセージの中ほどで原因を示します。

* `Claude.ai login expired` と `Claude.ai login was rejected`：保存済みのログイントークンが期限切れになったか取り消されたため、claude.ai がそのトークンを受け付けなくなりました
* `OAuth token unavailable`：接続の認証情報の更新時期が来たときに、Claude Code に保存済みのログイントークンがありませんでした
* `OAuth token refresh failed`：Claude Code の再接続中に claude.ai が保存済みのログイントークンを拒否し、トークンを更新しても新しいトークンが得られませんでした
* `JWT refresh failed: no OAuth token`：Claude Code が更新に使用する保存済みのログイントークンを見つけられませんでした
* `Signed out of Claude`：このマシンでサインアウトしたため（たとえば別のターミナルで `/logout` を実行した場合）、Claude Code には接続の更新に使用する保存済みのログインが残っていません

**対処方法：**

* `/login` を実行して再度サインインします
* `/remote-control` を実行してセッションを再接続します。`run /login to restore Remote Control` で終わるメッセージでは、この手順は不要です。サインインすると Claude Code が自動的に再接続します。

v2.1.224 より前では、`OAuth token refresh failed — run /login to re-authenticate` は `OAuth token refresh failed — re-authenticate, then re-enable Remote Control` と表示され、`JWT refresh failed: no OAuth token — run /login` は `no OAuth token available for recovery (code <N>)` と表示されていました。`Claude.ai login expired`、`Claude.ai login was rejected`、`OAuth token unavailable` のメッセージは v2.1.225 で追加されました。

v2.1.238 より前では、Claude Code は現在 `Signed out of Claude` と表示されるケースを `JWT refresh failed: no OAuth token — run /login` として報告し、ログインの更新で 1 回でも応答が得られないとすぐに `Claude.ai login expired — run /login to restore Remote Control` で Remote Control を停止していました。

<h3 id="remote-control-stopped-because-the-signed-in-account-changed">
  サインイン中のアカウントが変更されたため Remote Control が停止しました
</h3>

Claude Code は、[Remote Control](/docs/ja/remote-control) セッション中に、このマシンで別の claude.ai アカウントまたは組織にサインインしたときにこの行を表示します。この切り替えは Claude Code セッションの外部で行われたもので、たとえば別のターミナルで `/login` を実行した場合が該当します。

`/login` でサインインした状態で開始した Remote Control セッションは、その時点でサインインしていた claude.ai アカウントと組織に属します。

```text theme={null}
Remote Control disconnected — signed-in claude.ai account or organization changed on this machine — run /remote-control to start a session for the current account, or /login to switch back, then /remote-control
```

Claude Code は、アカウントまたは組織が変更されたことを claude.ai が確認するとすぐに Remote Control セッションを停止します。ローカルセッションは Remote Control なしで実行され続けます。

**対処方法：**

* `/remote-control` を実行して、現在のアカウントまたは組織で新しい Remote Control セッションを開始します
* 元に戻すには、`/login` を実行して以前のアカウントまたは組織に再度サインインします。その後、`/remote-control` を実行します。

v2.1.234 より前では、Claude Code セッションの外部で別のアカウントまたは組織に切り替えても、Claude Code はそれを検知しませんでした。Claude Code は、その後の Remote Control サーバーへのリクエストが `Remote Control server rejected the request (HTTP 404)` で失敗するまで、Remote Control セッションの接続を維持していました。この失敗は、切り替えから数時間後に発生することもありました。

<h3 id="remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts">
  セッションを実行しているアプリがサインアウトまたはアカウントを切り替えたため Remote Control が停止しました
</h3>

Claude デスクトップアプリまたは IDE がセッションをホストしている場合、Claude Code はログイントークンを `/login` からではなくそのアプリから取得します。claude.ai がそのトークンを拒否すると、Claude Code はアプリに新しいトークンを要求します。アプリがサインアウトしている、または別の Claude アカウントにサインインしていると応答した場合、Claude Code は [Remote Control](/docs/ja/remote-control) セッションを終了し、次のいずれかの行をアプリに送信します。

```text theme={null}
Remote Control stopped — the app running this session is now signed in to a different Claude account
Remote Control stopped — the app running this session is signed out of Claude. Sign in there, then turn Remote Control back on
```

ローカルセッションは Remote Control なしで実行され続けます。

**対処方法：**

* アプリがサインアウトしている場合は、アプリに再度サインインしてから、アプリで Remote Control を再度オンにします
* アプリがアカウントを切り替えた場合、Claude Code は終了したセッションを新しいアカウントで続行できません。そのアカウントで新しい Remote Control セッションを開始してください。

v2.1.238 より前では、Claude Code はどちらの場合も、[Remote Control がログインを更新できませんでした](#remote-control-couldnt-refresh-your-login)に記載されている `run /login` メッセージをアプリに送信していました。

<h3 id="oauth-token-revoked-or-expired">
  OAuth トークンが取り消された、または期限切れです
</h3>

保存済みのログインが無効になりました。トークンが取り消された場合は、すべての場所でサインアウトしたか、管理者がアクセスを削除したことを意味します。トークンの有効期限が切れた場合は、セッション中に自動更新が失敗したことを意味します。

どちらのメッセージも、Claude Code が送信したリクエストに対して API が返した拒否を報告するものです。更新の失敗後に保存済みのログインがすでに消去されている場合は、代わりに[ログインの有効期限切れ](#login-expired)が表示されます。[`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars) の長期間有効なトークンで認証している場合も、そのトークンが期限切れになるか取り消されたときに同じメッセージが表示されます。

```text theme={null}
OAuth token revoked · Please run /login
Please run /login · API Error: 401 OAuth token has expired ...
```

[非対話モード](/docs/ja/headless)（`-p`）と [Agent SDK](/docs/ja/agent-sdk/overview) では、メッセージは次のようになり、構造化エラーコードは `authentication_failed` です。

```text theme={null}
Failed to authenticate: OAuth token revoked. Please log in again or contact your administrator.
Failed to authenticate. API Error: 401 OAuth token has expired ...
```

v2.1.287 より前では、非対話モードと Agent SDK での取り消しのメッセージは `Your account does not have access to Claude. Please login again or contact your administrator.` でした。

**対処方法：**

* Claude Code のプロンプトで `/login` を実行して再度サインインします
* `-p` コマンドまたは Agent SDK プログラムが保存済みのログインを使用している場合は、同じ環境で `claude` を実行して `/login` を完了してから、コマンドまたはプログラムを再度実行します。対話的にサインインできない自動化では、[`ANTHROPIC_API_KEY`](/docs/ja/env-vars) で認証するか、[`claude setup-token` で長期間有効なトークンを生成](/docs/ja/authentication#generate-a-long-lived-token)します。
* `CLAUDE_CODE_OAUTH_TOKEN` 環境変数で認証している場合、リクエストが 401 で失敗した後も、Claude Code は保存済みのログインのトークンに切り替えるのではなく、設定した値を送信し続けます。[`/status`](/docs/ja/commands) では、この認証情報は `CLAUDE_CODE_OAUTH_TOKEN` と表示される `Auth token` 行として示されます。[`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で新しいトークンを生成してそれを使って再起動するか、変数の設定を解除して `/login` を実行します。v2.1.225 より前では、Claude Code がセッション中に変数の値を保存済みのログインの短期間有効なアクセストークンに置き換えることがあり、そのトークンの有効期限が切れると、セッションは再び 401 エラーで失敗していました。
* 起動のたびにログインを求められる場合は、[トラブルシューティング](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired)にあるシステムクロックの確認と macOS の認証情報ストレージの復旧手順を参照してください
* `403 Forbidden` や OAuth のブラウザに関する問題など、その他の失敗については、[ログインと認証](/docs/ja/troubleshoot-install#login-and-authentication)を参照してください

<h3 id="api-error-401-invalid-authentication-credentials">
  API Error: 401 Invalid authentication credentials
</h3>

API は認証情報の形式を認識しましたが、その背後にあるアカウントまたは組織を拒否しました。Anthropic がこのメッセージを返すのは、認証情報が最近取り消された場合、組織が無効化されたかユーザーのアクセスを削除した場合、またはアカウント自体が無効化された場合です。したがって、トークンの有効期限切れが原因ではありません。認証情報は保存済みのログインまたは承認済みの `ANTHROPIC_API_KEY` のいずれかであり、それぞれ修正方法が異なるため、まず `/status` を実行してどちらが有効かを確認してください。

```text theme={null}
Please run /login · API Error: 401 Invalid authentication credentials
```

**対処方法：**

* `/status` に、使用されていないと示されていない `API key` 行が表示される場合、承認済みの [`ANTHROPIC_API_KEY`](/docs/ja/authentication#authentication-precedence) が有効な認証情報であり、ログインより優先されるため、`/login` では置き換えられません。Claude Console でキーをローテーションするか、`unset ANTHROPIC_API_KEY`（PowerShell では `Remove-Item Env:ANTHROPIC_API_KEY`）を実行してサブスクリプションにフォールバックします。
* `/status` にログインのみが表示される場合は、`/login` を 1 回実行します。認証情報が取り消されていた場合は、新しいログインで置き換えられます。
* 同じログインアカウントで同じメッセージが再び表示される場合、そのアカウントまたは組織はもう有効ではありません。`/status` が報告するアカウントと組織を確認し、組織の管理者にアクセスの復元を依頼してください。
* [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が [LLM ゲートウェイ](/docs/ja/llm-gateway)を指している場合、`401` の後のテキストは Anthropic ではなくゲートウェイのメッセージであり、`/login` では変わりません。代わりに、ゲートウェイが想定する認証情報を修正してください。

<h3 id="login-expired">
  ログインの有効期限切れ
</h3>

Claude Code が保存済みの claude.ai ログインを更新しようとしたところ、OAuth サービスが保存済みのリフレッシュトークンを拒否したため、Claude Code は保存済みの認証情報を消去しました。新しい認証情報を作成できるのは `/login` のみであるため、それ以降、各モデルリクエストは API に到達する前にローカルでこのメッセージとともに停止します。

v2.1.206 より前では、Claude Code は環境に残っている認証情報でモデルリクエストをそのまま送信していたため、サインインを促す代わりに、すべてのモデルが[選択したモデルに問題があります](#theres-an-issue-with-the-selected-model)または 401 で失敗していました。

```text theme={null}
Login expired · Please run /login
```

[非対話モード](/docs/ja/headless)（`-p`）と [Agent SDK](/docs/ja/agent-sdk/overview) では、メッセージは次のようになり、構造化エラーコードは `authentication_failed` です。

```text theme={null}
Failed to authenticate: OAuth session expired and could not be refreshed
```

これは [OAuth トークンが取り消された、または期限切れです](#oauth-token-revoked-or-expired)とは異なる状態です。そちらのメッセージは API が返した拒否を報告します。`Login expired` は、すでに更新に失敗したログインに対して Claude Code 自身が生成するものであり、リクエストは送信されません。ログインが古くなったのではなくアカウント自体が停止されているために更新が失敗した場合、Claude Code は代わりに[アカウントが保留中です](#your-account-is-on-hold)を表示します。

API キー、[`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars)、またはサードパーティプロバイダーで認証されたセッションは保存済みのログインを使用しないため、このメッセージが表示されることはありません。

リクエストが失敗する前にこの状態を確認できます。[`/status`](/docs/ja/commands) には、`Expired — log in again` と表示される `Login` 行と、期限切れのログインについて保存されている組織とメールアドレスが表示されます。この行は、保存済みのログインが有効な認証情報であり、かつ更新できなくなった場合にのみ表示されます。別の方法で認証されたセッションでは、期限切れのログインが保存されたままでも、この行は表示されません。v2.1.210 より前では、認証情報が消去されて報告する内容がなくなるため、この状態の `/status` にはログインが存在していたことを示すものが何も表示されませんでした。

**対処方法：**

* `/login` を実行して再度サインインします。サインインせずに再試行すると、すべてのリクエストで同じメッセージが表示されます。
* 別の Claude Code ウィンドウで claude.ai アカウントを使ってサインインする場合、このセッションがいつ自動的にそのログインを使い始めるかについては、[ログインしていません](#not-logged-in)を参照してください。
* 非対話モードでは、同じ環境で `claude` を実行して `/login` を完了してから、コマンドを再実行します。対話的にサインインできない自動化では、`ANTHROPIC_API_KEY` で認証するか、[`claude setup-token` で長期間有効なトークンを生成](/docs/ja/authentication#generate-a-long-lived-token)します。
* サインインが失敗し続ける場合は、[ログインと認証](/docs/ja/troubleshoot-install#login-and-authentication)を参照してください

<h3 id="could-not-refresh-your-login">
  別の Claude Code プロセスが更新中のためログインを更新できませんでした
</h3>

このメッセージは、ログインが拒否されたことを意味するものではありません。保存済みの claude.ai ログインの有効期限が切れており、更新が必要でした。同じマシン上の別の Claude Code プロセスが共有の更新ロックを保持していたか、ロックを残したまま終了しており、このセッションが待機している間に更新が進みませんでした。Claude Code は送信前にリクエストを停止します。

```text theme={null}
Could not refresh your login because another Claude Code process is refreshing it (or exited mid-refresh) · Try again in a minute; if it keeps happening, close other Claude Code windows or sign in again with /login
```

[非対話モード](/docs/ja/headless)（`-p`）と [Agent SDK](/docs/ja/agent-sdk/overview) では、メッセージは次のようになり、構造化エラーコードは `server_error` です。

```text theme={null}
Failed to refresh OAuth token: another Claude Code process is refreshing it or exited mid-refresh. This is usually transient; retry in a minute, and if it persists close other Claude Code processes or sign in again
```

API キー、[`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars)、またはサードパーティプロバイダーで認証されたセッションは保存済みのログインを使用しないため、このメッセージが表示されることはありません。

**対処方法：**

* 1 分後に再試行します。別のプロセスが先に更新を完了した場合、このセッションは更新されたログインを使用します。
* メッセージが繰り返し表示される場合は、他の Claude Code ウィンドウとプロセスを閉じてから再試行します。
* 他に Claude Code プロセスが実行されていないのにメッセージが表示される場合は、`/login` を実行します。再度サインインする場合は、更新ロックを待機しません。

<h3 id="couldnt-save-your-login">
  ログインを保存できませんでした
</h3>

claude.ai でサインインしましたが、Claude Code がログインを認証情報ストアに保存できなかったため、ログインが完了しませんでした。macOS では、同じセッション中に Claude Code がすでにログインキーチェーンの認証情報を読み取りまたは保存した後で、スリープやアイドルなどによってキーチェーンがロックされた場合に発生することがあります。

```text theme={null}
Couldn't save your login. If your Mac's keychain is locked, unlock it and log in again.
Couldn't save your login. Try logging in again.
```

1 つ目の形式は macOS で表示され、2 つ目はそれ以外のすべての環境で表示されます。タイムアウトや読み取れないストアなど、一時的な認証情報ストアの失敗でも同じメッセージが表示されます。

**対処方法：**

* macOS では、ログインキーチェーンのロックを解除してから、再度 `/login` を実行します
* その他のプラットフォームでは、再度 `/login` を実行します
* それでもログインが保存されない場合は、キーチェーンのロック解除コマンドやその他の認証情報ストレージの復旧手順について、[ログインしていない、またはトークンの有効期限切れ](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired)を参照してください

<h3 id="failed-to-start-oauth-callback-server">
  OAuth コールバックサーバーの起動に失敗しました
</h3>

`/login`、`claude auth login`、または `claude setup-token` がブラウザ経由でサインインする際、Claude Code はブラウザがサインイン結果を返せるように `127.0.0.1` でリッスンポートを開きます。このメッセージは、Claude Code がそのポートを開けなかったことを意味し、ブラウザウィンドウやログイン URL が表示される前にサインインが停止します。

```text theme={null}
Failed to start OAuth callback server: Failed to start server. Is port 0 in use?
```

メッセージが `Is port 0 in use?` で終わる場合、IPv4 ループバックアドレス `127.0.0.1` でリッスンする試み自体が失敗しています。ログイン URL が生成される前に失敗が発生するため、回避策として `Paste code here if prompted` フローを使用することはできません。

**対処方法：**

* ローカルリスナーを使わずにすぐにサインインするには：claude.ai サブスクリプションを使用している場合は、サインインが機能するマシンで [`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) を実行し、出力されたトークンをこのマシンで `CLAUDE_CODE_OAUTH_TOKEN` として設定します。それ以外の場合は、`ANTHROPIC_API_KEY` に [Claude Console](https://platform.claude.com/settings/keys) のキーを設定します。Claude Code が認証情報をどのように選択するかについては、[認証の優先順位](/docs/ja/authentication#authentication-precedence)で説明しています。
* 代わりにこのマシンでブラウザによるサインインを使用するには、Claude Code が `127.0.0.1` でリッスンできる必要があります。サンドボックス内で実行している場合は、サンドボックスのポリシーでローカルポートでのリッスンが許可されていることを確認してから、再度 `/login` を実行します。リッスンできるはずなのに失敗する場合は、`/feedback` を実行して、環境の詳細をレポートに含めてください。

<h3 id="claude-login-not-accepted">
  Claude ログインが受け付けられませんでした
</h3>

[クラウドセッション](/docs/ja/claude-code-on-the-web)を開始しようとしたところ、サーバーが 401 で作成を拒否しました。このマシンが送信した Claude ログインをサーバーが受け付けなかったためで、通常はログインの有効期限が切れたか取り消されたことが原因です。

行の最初の部分は、サーバーが理由を返した場合はその理由になります。それ以外の場合、行は次のようになります。

```text theme={null}
Claude login not accepted · Run /login, then try again
```

**対処方法：**

* `/login` を実行してサインインを完了してから、再度セッションを開始します

<h3 id="artifacts-need-a-claude-ai-login">
  アーティファクトには claude.ai ログインが必要です
</h3>

セッションにアーティファクトで使用できる claude.ai ログインがないため、Claude Code は[アーティファクト](/docs/ja/artifacts)の公開または読み取りを拒否しました。

メッセージはどの形式でも同じ文言で始まり、その後にセッションの認証方法に応じた対処法が続きます。競合する認証情報がない場合は、次のようになります。

```text theme={null}
Artifacts need a claude.ai login. Run /login and select "Claude account with subscription", then retry — the "Anthropic Console account" option does not provide claude.ai credentials.
```

**対処方法：**

* `/login` を実行し、**Claude account with subscription** を選択します。**Anthropic Console account** オプションでは claude.ai の認証情報は提供されません。
* メッセージに優先される認証情報（`ANTHROPIC_API_KEY`、`apiKeyHelper` 設定、以前の `/login` で保存された Console キーなど）が示されている場合は、メッセージの指示どおりにそれを削除してから、`/login` を実行します
* メッセージに、このリモートセッションはそれを起動したマシンを通じて認証されると示されている場合は、そのマシンで claude.ai にサインインしてから、セッションを再接続します
* メッセージに、認証情報がセッションのホスト環境によって注入されていると示されている場合、そのセッションでは変更できません。claude.ai にサインインしているセッションを開始してください
* プラン、モデルプロバイダー、組織のポリシーなど、アーティファクトのその他の要件については、[利用可能性](/docs/ja/artifacts#availability)を参照してください

<h3 id="administrator-policy-requires-a-cloud-gateway-sign-in">
  管理者ポリシーにより Cloud ゲートウェイへのサインインが必要です
</h3>

このマシンの管理者による[管理設定](/docs/ja/managed-settings)で、[`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) が `"gateway"` に設定されているか、[`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) が設定されています。この場合、`CLAUDE_CODE_USE_BEDROCK` などの変数でクラウドプロバイダーを選択しない限り、Claude Code は [Claude apps gateway](/docs/ja/claude-apps-gateway) へのサインインのみを受け付けます。次の 2 つのメッセージのいずれかが表示されます。

```text theme={null}
Not signed in to the Cloud gateway — run /login.
```

セッションにゲートウェイへのサインインがない場合（たとえば、ポリシーがマシンに適用されてから `/login` を実行していない場合）、モデルリクエストはこのメッセージで失敗します。

マシンに Anthropic が発行した認証情報もあり、管理設定で `forceLoginMethod` または `forceLoginOrgUUID` が設定されている場合、Claude Code は代わりに起動時に終了します。その認証情報は、`ANTHROPIC_API_KEY` または `ANTHROPIC_AUTH_TOKEN` 変数、`apiKeyHelper` 設定、または以前の Claude Console ログインで保存された API キーのいずれかです。

起動時のメッセージには、セッションに設定されている認証情報、その設定場所、およびそれを削除する手順が示されます。たとえば、シェルで `ANTHROPIC_API_KEY` 変数が設定されている場合は、次のようになります。

```text theme={null}
Administrator policy requires a Cloud gateway sign-in on this machine, but this session is configured with an API key from ANTHROPIC_API_KEY, which a gateway machine does not accept.

To continue: unset ANTHROPIC_API_KEY (or run in a shell without it), then run claude and sign in with /login.
```

**対処方法：**

* `Not signed in to the Cloud gateway` の場合は、`/login` を実行して **Cloud gateway** 画面でサインインを完了します
* 起動時のメッセージの場合は、メッセージの末尾にある手順に従って認証情報を削除します
* このマシンでゲートウェイが必要ないはずだと考える場合は、マシンを管理している管理者に、管理設定から `forceLoginMethod` と `forceLoginGatewayUrl` を削除するよう依頼します

v2.1.284 より前では、起動時のメッセージは設定されている認証情報を示すのではなく、考えられる認証情報を列挙していました。メッセージは `Administrator policy requires a Cloud gateway sign-in on this machine; the Anthropic-issued credential configured here (ANTHROPIC_API_KEY, ANTHROPIC_AUTH_TOKEN, or apiKeyHelper) is not used.` で始まっていました。この文言が表示され、どの認証情報を削除すべきかわからない場合は、v2.1.284 以降に更新して、再度 `claude` を起動してください。

v2.1.265 では、リグレッションにより、マシンに管理者の要件がない場合でも、API キー、`apiKeyHelper`、またはカスタムヘッダーで認証する一部の LLM ゲートウェイおよびプロキシの構成で 1 つ目のメッセージが表示されていました。v2.1.266 以降に更新してください。設定を変更する必要はありません。

v2.1.261 より前では、`forceLoginMethod` を `"gateway"` に設定したマシンで、Claude Code はモデルリクエストを失敗させる代わりに残っていた保存済みのログインを使用し、設定された環境の認証情報については、起動時のメッセージではなく `This machine's managed settings require a first-party login` と報告していました。

<h3 id="your-account-is-on-hold">
  アカウントが保留中です
</h3>

ログインの背後にある Claude アカウントが停止されています。Claude Code は、保存済みのログインを更新しようとして保留を検知したときに 1 つ目のメッセージを表示し、ブラウザで完了したサインインで保留が報告されたときに 2 つ目のメッセージを表示します。

```text theme={null}
Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted
Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted
```

保留はログインではなくアカウントにかかっているため、同じアカウントで再度サインインしてもメッセージは解消されません。[非対話モード](/docs/ja/headless)（`-p`）と [Agent SDK](/docs/ja/agent-sdk/overview) では、構造化エラーコードは `account_on_hold` です。v2.1.235 より前では、Claude Code は保留中のアカウントを [Login expired · Please run /login](#login-expired) として報告していましたが、その復旧手順では保留を解除できません。

**対処方法：**

* メッセージ内のリンクを開いて、保留の詳細を確認するか、異議を申し立てます
* 保留の影響を受けない別の Claude アカウントまたは API キーがある場合は、保留が解決されるまで作業を続けられます。そのアカウントで `/login` を実行するか、`ANTHROPIC_API_KEY` でキーを設定してください

<h3 id="anthropic-profile-login-expired">
  Anthropic プロファイルのログインの有効期限切れ
</h3>

Claude Code は Anthropic 認証情報プロファイルを通じて認証していますが、そのプロファイルに保存されたログイン認証情報の有効期限が切れており、プロファイルには Claude Code が更新に使用できるリフレッシュ用の認証情報がありません。再試行しても同じ期限切れの認証情報を読み取るだけなので、Claude Code は再試行せずに各リクエストをローカルで停止します。

```text theme={null}
Anthropic profile login expired · Re-authenticate your Anthropic profile
Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile
```

このメッセージは、有効な認証情報が Anthropic 認証情報プロファイルから取得される場合にのみ表示されます。対象となるのは、`ANTHROPIC_PROFILE` 環境変数で選択したプロファイル、Claude Code が Anthropic 設定ディレクトリ内でアクティブなプロファイルとして検出したプロファイル、または [API キーなしでサインイン](/docs/ja/authentication#sign-in-without-an-api-key)したときに Claude Code が書き込んだプロファイルです。API キー、`ANTHROPIC_AUTH_TOKEN` などのベアラートークン、またはサードパーティプロバイダーで認証するセッションでは、このメッセージは表示されません。

[キーなしのサインインを提供している](/docs/ja/authentication#sign-in-without-an-api-key)マシンでは、`/login` を実行し、Anthropic Console アカウントを選択して再度サインインすると、キーなしの Console サインインまたは Claude Platform CLI の `ant auth login` が書き込んだプロファイルを更新できます。Claude Code はそのプロファイル内の期限切れの認証情報を置き換えます。フェデレーションプロファイルや別のツールが作成したプロファイルでは、`/login` で認証情報は更新されません。どちらの形式が表示されるかは、プロファイルを自分で選択したか、Claude Code が検出したかによって異なります。

* `ANTHROPIC_PROFILE` を明示的に設定した場合、メッセージは `Re-authenticate your Anthropic profile` で終わります。
* Claude Code が設定ディレクトリからプロファイルを検出した場合、メッセージでは `/login` が提示されます。Claude Code は、検出されたプロファイルよりも機能する `/login` を優先し、代わりに claude.ai または Console アカウントで認証するためです。v2.1.234 より前では、この場合も Claude Code は `Re-authenticate your Anthropic profile` の形式を表示していました。

**対処方法：**

* プロファイルに再度サインインしてから再試行します。[キーなしのサインインを提供している](/docs/ja/authentication#sign-in-without-an-api-key)マシンでは、キーなしの Console サインインまたは Claude Platform CLI の `ant auth login` が書き込んだプロファイルについては、`/login` を実行して Anthropic Console アカウントを選択します。その他のプロファイルについては、それを作成したツールを使用します
* 管理者がプロファイルの認証情報をプロビジョニングした場合は、新しい認証情報を発行するよう依頼します
* `/status` を実行して、有効な認証情報ソースとプロファイル名を確認します
* プロファイルの使用をやめるには、`ANTHROPIC_PROFILE` を設定している場合はその設定を解除してから、`/login` や `ANTHROPIC_API_KEY` などの別の方法で認証します

<h3 id="oauth-scope-requirement">
  OAuth スコープの要件
</h3>

保存されているトークンは、新しい機能に必要な権限スコープが導入される前のものです。

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**対処方法：**

* `/login` を実行して、現在のスコープを持つ新しいトークンを取得します。事前にログアウトする必要はありません。

<h3 id="claude-ai-rejected-the-session-token">
  claude.ai がセッショントークンを拒否しました
</h3>

[claude.ai コネクタ](/docs/ja/mcp#use-mcp-servers-from-claude-ai)のリクエストが、claude.ai が Claude Code のログインのトークンを拒否したために失敗しました。拒否されたトークンはログインのものであり、claude.ai におけるコネクタ自体の認可ではないため、コネクタを再度認可しても解決しません。`/mcp` では、コネクタは `session token rejected` と表示され、その詳細ビューには次のように表示されます。

```text theme={null}
claude.ai rejected the session token. Run /login, then reconnect.
```

**対処方法：**

* `/login` を実行して再度サインインします
* `/mcp` からコネクタを再接続するか、`/mcp reconnect <server>` を実行します。再度サインインする前に再接続しても、コネクタは同じ状態のままです。`/mcp` パネルの **Reconnect** オプションでは `your claude.ai session token was rejected` と報告されますが、入力する `/mcp reconnect <server>` の形式では、トークンがまだ拒否されていても再接続の成功が報告されます。

v2.1.222 より前では、Claude Code は代わりにコネクタを認証が必要な状態としてマークしていたため、コネクタの認可フローを完了しても状態が解消されないにもかかわらず、そのフローに誘導していました。

<h3 id="mcp-server-needs-you-to-sign-in-again">
  MCP サーバーへの再サインインが必要です
</h3>

リモートの [MCP サーバー](/docs/ja/mcp)が、セッション中のツール呼び出しで認証情報を拒否しました。通常は、サインインまたはトークンの有効期限が切れたか、ツールに必要な権限がトークンにないことが原因です。ツール呼び出しは失敗し、`/mcp` はサーバーを[認証が必要](/docs/ja/mcp#authenticate-with-remote-mcp-servers)な状態としてマークします。

Claude Code からサインインするサーバー（claude.ai コネクタを含む）の場合は、サインインの有効期限が切れたか取り消されています。

```text theme={null}
MCP server "<name>" needs you to sign in again (run /mcp to re-authenticate)
```

`/mcp` を実行してサーバーを選択し、そのメニューから再度サインインします。

[`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) スクリプトで設定されたサーバーの場合、Claude Code はこのメッセージを表示する前に、すでにヘルパーを再実行して呼び出しを 1 回再試行しています。

```text theme={null}
MCP server "<name>" rejected the credential from its headersHelper (check the helper and run /mcp to reconnect, or to authenticate if the server also uses OAuth)
```

ヘルパーがサーバーで受け付けられる認証情報を返すことを確認してから、`/mcp` から再接続します。再接続するとヘルパーが再度実行されます。

設定に静的な `Authorization` ヘッダーがあるサーバーの場合：

```text theme={null}
MCP server "<name>" rejected the Authorization header in its config (update it, then run /mcp to reconnect)
```

サーバーが設定されている場所でヘッダーの値を更新してから、`/mcp` から再接続します。

v2.1.273 より前では、サインインの期限切れ、`headersHelper`、`Authorization` ヘッダーのいずれのケースでも `MCP server "<name>" requires re-authorization (token expired)` と表示されていました。

サーバーは、HTTP 403 `insufficient_scope` でツール呼び出しを拒否し、スコープの認可を求めることもあります。そのスコープがトークンにすでに含まれている場合もあります。メッセージにはそのスコープが示されます。

```text theme={null}
MCP server "<name>" needs additional permissions (scope: "<scope>") — run /mcp to re-authenticate
```

`/mcp` を実行してサーバーを選択し、そのメニューから再度認証します。

サーバーの設定で [`oauth.scopes`](/docs/ja/mcp#restrict-oauth-scopes) も [`authServerMetadataUrl`](/docs/ja/mcp#override-oauth-metadata-discovery) も設定されていない場合、Claude Code はサーバーが示したスコープを要求します。どちらかが設定されている場合、Claude Code は代わりにその設定のスコープを要求します。`oauth.scopes` を固定している場合は、再度認証する前に、不足しているスコープをそのリストに追加してください。

v2.1.274 より前では、このケースでは `needs you to sign in again` メッセージが表示され、v2.1.273 より前では他のケースと同様に `requires re-authorization (token expired)` が表示されていました。

<h3 id="mcp-server-url-is-missing-or-not-a-valid-url">
  MCP サーバーの URL がないか、有効な URL ではありません
</h3>

サーバーに設定された `url` が URL として解析できないため、Claude Code はリモート MCP サーバーの OAuth サインインの開始を拒否しました。Claude Code がそのサーバーについて報告すべきより具体的な設定の問題がない限り、シェルで [`claude mcp login <name>`](/docs/ja/mcp#authenticate-from-the-command-line) を実行すると、拒否は次のように出力されます。

```text theme={null}
Couldn't complete authentication for "<name>": This server's URL is missing or not a valid URL, so sign-in can't start. Fix the URL in its MCP config (or set the environment variable it uses) and try again.
```

**対処方法：**

* サーバーが設定されている場所でエントリの `url` をサーバーの実際のエンドポイントに設定するか、その [`${VAR}` 参照](/docs/ja/mcp#environment-variable-expansion-in-mcp-json)が示す環境変数を設定してから、再度サインインを実行します。

<h3 id="issuer-mismatch-in-authorization-response">
  認可レスポンスの発行者の不一致
</h3>

[MCP OAuth サインイン](/docs/ja/mcp#authenticate-with-remote-mcp-servers)中に、認可サーバーが、サーバーの OAuth メタデータから Claude Code が想定した発行者とは異なる発行者を示す `iss` パラメーターを付けて、Claude Code にリダイレクトしました。このステップで発行者が誤っていることは認可サーバーの混同攻撃（mix-up attack）の兆候であるため、Claude Code は認可コードを交換せずにサインインを失敗させます。Claude Code は、ブラウザでのサインイン後に `/mcp` サーバーメニューにエラーを表示します。

```text theme={null}
Issuer mismatch in authorization response (RFC 9207): expected "https://auth.example.com", received "https://other.example.com"
```

`expected` はサーバーの OAuth メタデータにある発行者で、`received` はリダイレクトに含まれていた `iss` の値です。リダイレクトに `iss` パラメーターが含まれていないサインインはチェックに合格します。ただし、サーバーのメタデータで `authorization_response_iss_parameter_supported` が設定されている場合は、Claude Code はサインインを失敗させます。

**対処方法：**

* `/mcp` から再度サインインを試します
* エラーが繰り返される場合は、サーバーの運営者に報告します。修正はサーバー側で行う必要があります。認可サーバーは、メタデータで公開しているものと同じ発行者を `iss` パラメーターで返す必要があります
* サーバーの修正中に接続するには、[`MCP_SDK_GENERATION=v1`](/docs/ja/env-vars) を指定して Claude Code を起動します。その[ランタイム](/docs/ja/mcp#mcp-client-runtimes)ではこのチェックが実行されません。これにより混同攻撃に対する保護が失われるため、サーバー側での修正を優先してください

v2.1.232 より前では、Claude Code は段階的なロールアウトの対象となった場合、または `MCP_SDK_GENERATION=v2` を設定した場合にのみ v2 ランタイムを使用していました。

<h3 id="refusing-to-send-credentials-to-non-https-token-endpoint">
  非 https のトークンエンドポイントへの認証情報の送信を拒否しました
</h3>

[v2 ランタイム](/docs/ja/mcp#mcp-client-runtimes)では、Claude Code は [MCP OAuth](/docs/ja/mcp#authenticate-with-remote-mcp-servers) のトークンリクエストを、HTTPS で提供されているトークンエンドポイント、または `localhost`、`127.0.0.1`、`::1` にあるトークンエンドポイントにのみ送信します。このメッセージは、サーバーのトークンエンドポイントがそのいずれでもないため、Claude Code がリクエストを送信する前に停止したことを意味します。これはブラウザでのサインイン後に発生するため、ブラウザのステップは先に成功します。また、Claude Code がサーバーのトークンを更新するたびにも発生します。

完全な形式では、このメッセージは MCP SDK から出力され、拒否したトークンエンドポイントが引用されます。デバッグログでは、サインインの場合は `Error during auth completion:`、更新の場合は `Token refresh failed:` の後に続きます。シェルでは、`claude mcp login <name>` が `Couldn't complete authentication for "<name>":` の後にこのメッセージを出力し、セッションでは `/mcp` がサーバーのメニューの下に表示します。

```text theme={null}
Refusing to send credentials to non-https token endpoint 'http://192.168.1.50:8123/oauth/token'. OAuth token requests MUST use TLS (localhost / 127.0.0.1 / ::1 are exempt).
```

Claude Code は、クエリ文字列やランダムに見える長いパスセグメントを含むサーバー URL を、機密である可能性があるものとして扱います。そのようなサーバーでは、MCP SDK が発生させたサインインエラーを、表示またはログに記録する前に秘匿化します。その場合、このエラーは `io` など、リリース間で変わる可能性のある短い名前に続けて、`from the MCP SDK for` と秘匿化されたサーバー URL が表示される形になります。MCP SDK からのその他のエラーも、その場合は同じ形になります。秘匿化されたメッセージがこのエラーである可能性があるのは、サーバーのトークンエンドポイントが `localhost`、`127.0.0.1`、`::1` 以外のアドレスにあるプレーンな `http://` の場合のみです。

**対処方法：**

* そのトークンエンドポイントを HTTPS で提供します。たとえば、TLS を終端するリバースプロキシやトンネルの背後にサーバーを配置し、`https://` アドレスを公開するようにサーバーを設定します
* サーバーを変更せずに接続するには、[`MCP_SDK_GENERATION=v1`](/docs/ja/env-vars) を指定して Claude Code を起動します。その[ランタイム](/docs/ja/mcp#mcp-client-runtimes)ではこのルールが適用されず、トークンリクエストはプレーンな HTTP で送信されます。この選択は終了するまで有効で、すべてのサーバーに適用されます。v1 ランタイムは[発行者のチェック](#issuer-mismatch-in-authorization-response)も省略するため、HTTPS でエンドポイントを提供する方法を優先してください

<h3 id="aws-credentials-expired-or-invalid">
  AWS 認証情報の有効期限切れまたは無効
</h3>

AWS セッショントークンの有効期限が切れたか、拒否されました。このメッセージは、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) または [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)から 401 が返されたときに表示されます。これらのプロバイダーは、期限切れのセキュリティトークンをこのように報告します。

中ほどのアクションのヒントは設定によって異なります。変わらない部分は先頭の `AWS credentials expired or invalid` です。

```text theme={null}
AWS credentials expired or invalid · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · API Error: 401 ...
```

v2.1.273 より前では、このメッセージは `awsAuthRefresh` が設定されている場合にのみ表示されていました。

**対処方法：**

* ヒントに認証情報がこの環境によって管理されていると示されている場合、Claude Code を起動したアプリが認証情報を所有しており、ここにあるその他の手順は適用されません。再試行するか、管理者に問い合わせてください
* [`awsAuthRefresh`](/docs/ja/amazon-bedrock#advanced-credential-configuration) が設定されている場合は、メッセージに示されたコマンド（`aws sso login --profile myprofile` など）を別のターミナルで実行し、ブラウザでのサインインを完了してから再試行します。それ以外の場合は、使用している AWS 認証情報（SSO サインイン、アクセスキー、API キー、プロキシトークン）を自分で更新します
* 対話セッションで `awsAuthRefresh` が設定されている場合は、代わりに `/login` を実行し、**3rd-party platform** を選択してから、**Using 3rd-party platforms** の下にある **Claude Platform on AWS · refresh credentials** を選択すると、Claude Code を再起動せずに同じコマンドを実行できます。[AWS 認証情報を設定する](/docs/ja/claude-platform-on-aws#1-configure-aws-credentials)を参照してください
* 更新コマンドが成功した後もエラーが繰り返される場合は、同じシェルとプロファイルで `aws sts get-caller-identity` を実行して、Claude Code の外部でその ID が有効であることを確認します

<h3 id="aws-authentication-failed">
  AWS 認証の失敗
</h3>

AWS プロバイダーが 403 を返したか、[Amazon Bedrock](/docs/ja/amazon-bedrock) が 401 を返しました。

Amazon Bedrock は期限切れのセキュリティトークンを 403 として報告しますが、IAM 権限の不足による `AccessDeniedException` などの認可の拒否も 403 として報告します。Claude Code はこの 2 つの原因を区別できません。

Amazon Bedrock からの 401 も、[AWS 認証情報の有効期限切れまたは無効](#aws-credentials-expired-or-invalid)ではなくここに該当します。Amazon Bedrock は期限切れのトークンを 401 として報告しないためです。そのエンドポイントからの 401 は、通常、企業のプロキシなど、リクエスト経路上の別の要素が原因です。

認証情報を更新すれば期限切れのトークンは解決しますが、その他の原因は解決できないため、メッセージでは両方を提示します。

```text theme={null}
AWS authentication failed · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · if credentials are current, check AWS permissions and model access · API Error: 403 ...
```

中ほどのアクションのヒントは設定によって異なります。変わらない部分は先頭の `AWS authentication failed` です。

403 が、指定されたモデル ID のモデルへのアクセス権がないという Amazon Bedrock の応答である場合、ヒントは代わりに、Amazon Bedrock コンソールでアカウントとリージョンに対してモデルを有効にするよう指示します。

v2.1.273 より前では、このメッセージは `awsAuthRefresh` が設定されている場合にのみ表示されていました。

**対処方法：**

* ヒントに認証情報がこの環境によって管理されていると示されている場合、Claude Code を起動したアプリが認証情報を所有しており、ここにあるその他の手順は適用されません。再試行するか、管理者に問い合わせてください
* 期限切れの認証情報が原因である場合に備えて、AWS 認証情報を更新します。設定されている場合はメッセージに示された [`awsAuthRefresh`](/docs/ja/amazon-bedrock#advanced-credential-configuration) コマンドを実行するか、SSO サインイン、アクセスキー、API キー、プロキシトークンを自分で更新します
* 認証情報が最新である場合は、[IAM 設定](/docs/ja/amazon-bedrock#iam-configuration)の IAM 権限が使用している ID にアタッチされていること、および選択したモデルがアカウントとリージョンで有効になっていることを確認します
* `aws sts get-caller-identity` を実行して、リクエストで使用されている ID を確認します

<h3 id="google-cloud-credentials-expired-or-invalid">
  Google Cloud 認証情報の有効期限切れまたは無効
</h3>

[Google Cloud's Agent Platform](/docs/ja/google-vertex-ai) 用の Google Cloud 認証情報の有効期限が切れたか、拒否されました。リクエストが 401 を返しました。Agent Platform は認証情報の期限切れをこのように報告します。

中ほどのアクションのヒントは設定によって異なります。変わらない部分は先頭の `Google Cloud credentials expired or invalid` です。

```text theme={null}
Google Cloud credentials expired or invalid · refresh your Google Cloud credentials (application default sign-in, or the key file in GOOGLE_APPLICATION_CREDENTIALS) and retry · API Error: 401 ...
```

**対処方法：**

* ヒントに認証情報がこの環境によって管理されていると示されている場合、Claude Code を起動したアプリが認証情報を所有しており、ここにあるその他の手順は適用されません。再試行するか、管理者に問い合わせてください
* アプリケーションのデフォルト認証情報で認証している場合は、メッセージに示された [`gcpAuthRefresh`](/docs/ja/google-vertex-ai#advanced-credential-configuration) コマンドまたは `gcloud auth application-default login` を実行し、サインインを完了してから再試行します
* `CLAUDE_CODE_SKIP_VERTEX_AUTH` を設定して [LLM ゲートウェイ](/docs/ja/llm-gateway)経由でルーティングしている場合は、`ANTHROPIC_AUTH_TOKEN` または `ANTHROPIC_CUSTOM_HEADERS` のゲートウェイトークンを更新してから再試行します
* サービスアカウントのキーファイルで認証している場合は、`GOOGLE_APPLICATION_CREDENTIALS` が有効なキーを指していることを確認します。[GCP 認証情報を設定する](/docs/ja/google-vertex-ai#3-configure-gcp-credentials)を参照してください
* 更新後もエラーが繰り返される場合は、同じシェルで `gcloud auth application-default print-access-token` を実行して、Claude Code の外部でその ID が機能することを確認します

v2.1.273 より前では、Agent Platform から 401 が返されると、代わりに一般的な `Please run /login` または `Failed to authenticate` メッセージが表示されていましたが、これでは Google Cloud 認証情報を更新できませんでした。

<h3 id="google-cloud-authentication-failed">
  Google Cloud authentication failed
</h3>

[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) が 403 を返しました。Agent Platform は、認証情報の期限切れではなく認可の拒否に対してこのステータスを使用します。通常は、認証に使用している ID に IAM 権限が不足しているか、プロジェクトでモデルが有効になっていないことが原因です。

中央部分のアクションヒントは環境によって異なります。変わらないのは先頭の `Google Cloud authentication failed` の部分です:

```text theme={null}
Google Cloud authentication failed · refresh your Google Cloud credentials (application default sign-in, or the key file in GOOGLE_APPLICATION_CREDENTIALS) and retry · if credentials are current, check GCP IAM permissions and Vertex AI model access · API Error: 403 ...
```

**対処方法:**

* ヒントに認証情報がこの環境によって管理されていると表示されている場合、Claude Code を起動したアプリが認証情報を管理しているため、ここに記載されているほかの手順は適用されません。再試行するか、管理者に問い合わせてください
* [IAM の設定](/docs/ja/google-vertex-ai#iam-configuration)に記載されているロールが、認証に使用している ID に付与されていることを確認します
* プロジェクトでモデルが有効になっていることを確認します。[モデルへのアクセスをリクエストする](/docs/ja/google-vertex-ai#2-request-model-access)を参照してください

v2.1.273 より前では、Agent Platform からの 403 に対して汎用的な `Please run /login` または `Failed to authenticate` メッセージが表示されていましたが、これでは Google Cloud の認証情報を更新できません。

<h3 id="microsoft-foundry-authentication-failed">
  Microsoft Foundry authentication failed
</h3>

[Microsoft Foundry](/docs/ja/microsoft-foundry) が 401 または 403 を返しました。リクエストに含まれる Azure の認証情報が拒否されたか、その背後にある ID が Foundry リソースへのアクセス権を持っていません。`/login` では Azure の認証情報を発行できません。中央部分のアクションヒントは環境によって異なります。変わらないのは先頭の `Microsoft Foundry authentication failed` の部分です:

```text theme={null}
Microsoft Foundry authentication failed · refresh your Foundry credential (ANTHROPIC_FOUNDRY_AUTH_TOKEN, ANTHROPIC_FOUNDRY_API_KEY, Azure sign-in for Entra, or your proxy token) and retry · if credentials are current, check access to the Foundry resource · API Error: 401 ...
```

**対処方法:**

* ヒントに認証情報がこの環境によって管理されていると表示されている場合、Claude Code を起動したアプリが認証情報を管理しているため、ここに記載されているほかの手順は適用されません。再試行するか、管理者に問い合わせてください
* [Azure の認証情報を設定する](/docs/ja/microsoft-foundry#2-configure-azure-credentials)で設定した認証情報を更新します。`ANTHROPIC_FOUNDRY_API_KEY` をローテーションするか、新しい `ANTHROPIC_FOUNDRY_AUTH_TOKEN` を発行するか、`az login` を実行してデフォルトの Microsoft Entra 認証情報チェーンで再度サインインできるようにします
* 認証情報が最新である場合は、ID が Foundry リソースへのアクセス権を持っていることを確認します。[Azure RBAC の設定](/docs/ja/microsoft-foundry#azure-rbac-configuration)を参照してください

v2.1.273 より前では、Microsoft Foundry からの 401 または 403 に対して汎用的な `Please run /login` または `Failed to authenticate` メッセージが表示されていましたが、これでは Azure の認証情報を更新できません。

<h3 id="could-not-load-aws-or-google-cloud-credentials">
  Could not load AWS or Google Cloud credentials
</h3>

Claude Code が実行されているマシン上で、AWS 認証情報プロバイダーチェーンまたは Google のアプリケーションのデフォルト認証情報から使用可能な認証情報を取得できなかったため、リクエストはクラウドプロバイダーに到達しませんでした。`·` の後の詳細には具体的な原因が示されます。たとえば、SSO セッションの期限切れ、`Could not load the default credentials` として報告されるアプリケーションのデフォルト認証情報の欠如、`invalid_grant` として報告される取り消されたサインインなどです。

```text theme={null}
API Error: Could not load AWS credentials · Could not load credentials from any providers. Check or refresh your AWS credentials and try again.
API Error: Could not load Google Cloud credentials · invalid_grant. Check or refresh your Google Cloud credentials and try again.
```

`-p` を使用する[非対話モード](/docs/ja/headless)および [Agent SDK](/docs/ja/agent-sdk/overview) では、構造化エラーコードは `cloud_credential_error` です。v2.1.267 より前では、メッセージには `API Error:` の後の詳細テキストのみが表示され、構造化コードは `server_error` または `unknown` でした。

**対処方法:**

* `aws sso login --profile myprofile` や `gcloud auth application-default login` など、プロバイダーのサインインコマンドを実行してから再試行します。Claude Code の外部で認証情報を確認する方法については、[Bedrock、Agent Platform、または Foundry の認証情報が読み込まれない](/docs/ja/troubleshoot-install#bedrock-agent-platform-or-foundry-credentials-not-loading)を参照してください
* 詳細が `AWS default-chain credential resolve timed out` の場合、チェーンは失敗したのではなくハングしているため、代わりに [AWS default-chain credential resolve timed out](#aws-default-chain-credential-resolve-timed-out) の手順に従ってください

<h3 id="aws-default-chain-credential-resolve-timed-out">
  AWS default-chain credential resolve timed out
</h3>

AWS のデフォルト認証情報プロバイダーチェーンが 60 秒以内に認証情報を生成しなかったため、Claude Code は解決処理を停止し、リクエストを失敗させました。このタイムアウトは、[Could not load AWS or Google Cloud credentials](#could-not-load-aws-or-google-cloud-credentials) の原因の 1 つです。失敗しているのはローカルでの認証情報の解決であり、リクエストは [Amazon Bedrock](/docs/ja/amazon-bedrock)、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、または [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint)に到達していません。Claude Code は[認証情報キャッシュ](/docs/ja/amazon-bedrock#credential-caching-and-resolution-timeout)をクリアして再試行してからこのエラーを表示するため、このエラーが表示された時点で、チェーンは繰り返しの試行で停止しています。

```text theme={null}
API Error: Could not load AWS credentials · AWS default-chain credential resolve timed out. Check or refresh your AWS credentials and try again.
```

一般的な原因は、AWS プロファイル内の `credential_process` コマンドが受け取れない入力を待機している場合や、コンテナまたは VM のインスタンスメタデータサービス（IMDS）がチェーンのプローブに応答しない場合です。

v2.1.267 より前では、メッセージは `API Error: AWS default-chain credential resolve timed out` でした。
v2.1.207 より前では、チェーンが停止するとリクエストは失敗せず、無期限に待機したままになっていました。

**対処方法:**

* 同じシェルで同じ `AWS_PROFILE` を使用して `aws sts get-caller-identity` を実行します。これもハングする場合は、プロファイルを修正してください。対話的にプロンプトを表示する `credential_process` コマンドがよくある原因です。
* Claude Code を起動する前にサインイン手順を完了します。例: `aws sso login --profile myprofile`
* `aws-vault` のようなラッパーを介した MFA 付き SSO など、チェーンで実行する対話的なサインインが正当に 60 秒以上必要な場合は、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) で上限をミリ秒単位で引き上げます

<h3 id="bedrock-setup-verification-timed-out-waiting-for-aws">
  Bedrock setup verification timed out waiting for AWS
</h3>

[Bedrock セットアップウィザード](/docs/ja/amazon-bedrock#sign-in-with-bedrock)の認証情報検証中に、認証情報の検索や ID チェックなどの AWS への呼び出しが 60 秒の制限時間内に完了しませんでした。ウィザードは待機を停止し、検証ステップを失敗させます:

```text theme={null}
Timed out after 60s waiting for AWS. Check your network and proxy settings; if a credential helper needs longer to prompt you, raise CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS.
```

この数値は設定されている上限を反映しています。デフォルトは 60 秒で、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) で設定した場合はその値になります。

一般的な原因は、SSO トークンの更新を含む AWS へのリクエストを停滞させるネットワークまたはプロキシや、表示されない入力を待機し続けている認証情報ヘルパーです。上限を引き上げるのは、ヘルパーが正当にさらに時間を必要とする場合のみにしてください。

AWS への単一のリクエストが停滞した場合、リクエストごとのタイムアウトによって失敗することもあり、その場合は同じステップでより短いメッセージが表示されます:

```text theme={null}
A request to AWS timed out. Check your network and proxy settings, then try again.
```

モデル固定ステップで同じタイムアウトが発生した場合、ウィザードはどちらのメッセージも表示せず、モデルを `unreachable` としてマークします。

**対処方法:**

* 同じシェルで `aws sts get-caller-identity` を実行します。これもハングする場合、停止の原因は Claude Code の外部、つまりネットワーク、プロキシ、または AWS プロファイル内の認証情報ヘルパーにあります。まずそれを修正してください。
* ウィザードを開く前に対話的なサインインを完了します。例: `aws sso login --profile myprofile`
* AWS プロファイル内の認証情報ヘルパーがプロンプトを表示するのに正当に 60 秒以上必要な場合は、[`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) で上限をミリ秒単位で引き上げます

<h3 id="cloud-gateway-session-expired">
  Cloud gateway session expired
</h3>

[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)を介してサインインしていますが、このマシンに保存されたゲートウェイセッションの有効期限が切れて更新できなかったか、ゲートウェイがそのセッションを受け付けなくなっています。たとえば、ゲートウェイの [JWT シークレットが置き換えられた](/docs/ja/claude-apps-gateway-deploy#jwt-secret-rotation)後などに発生します。`claude` を対話的に起動したときにこの行が表示された場合、セッションはゲートウェイからサインアウトした状態で開かれています:

```text theme={null}
Cloud gateway session expired — run /login to reconnect.
```

ゲートウェイの認証情報の有効期限が切れ、Claude Code がそれを更新できない場合、セッションの途中で同じ行が表示されることもあります。

[非対話](/docs/ja/headless)実行、バックグラウンドセッションやその他の無人セッション、または `claude auth` 以外の `claude` サブコマンドでは、ゲートウェイがセッションを受け付けなくなった場合、Claude Code は代わりに次のメッセージを表示して終了します:

```text theme={null}
Cloud gateway <url> no longer accepts this session. Start `claude` and sign in again with /login.
```

**対処方法:**

* セッションで `/login` を実行し、ブラウザでのサインインを完了します
* 非対話で起動した場合は、同じ環境で `claude` を起動して `/login` を実行してから、コマンドを再実行します

<h3 id="sign-in-timed-out-while-waiting-for-you-to-continue">
  Sign-in timed out while waiting for you to continue
</h3>

[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)でのサインイン中に、ゲートウェイがサインインしたアカウントを示し、Claude Code は認証情報を保存する前にその確認を求めました。確認画面がサインイン自体の有効期限を過ぎても開いたままになっており、ゲートウェイはそれを更新できるリフレッシュトークンを発行していなかったため、続行したときに Claude Code は何も保存しませんでした:

```text theme={null}
Sign-in timed out while waiting for you to continue. Try again.
```

**対処方法:**

* `/login` を再度実行し、サインインの有効期限が切れる前にアカウントを確認します

<h3 id="gateway-refused-the-request">
  Gateway refused the request
</h3>

[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway)を介してサインインしていますが、リクエストが 403 を返しました。ゲートウェイ、またはその背後にあるアップストリームがリクエストを拒否しました。再度サインインしても拒否は変わらないため、メッセージはゲートウェイ管理者に問い合わせるよう案内しています:

```text theme={null}
Gateway refused the request · signing in again won't change this — check with your gateway administrator · API Error: 403 ...
```

**対処方法:**

* ゲートウェイ管理者にリクエストの調査を依頼します。`API Error:` の末尾部分には、ゲートウェイが返した拒否内容が含まれています
* 管理者向け: ゲートウェイの[アクセス制御ルール](/docs/ja/claude-apps-gateway-config#http-tuning)は 403 を返し、[監査ログ](/docs/ja/claude-apps-gateway-deploy#logs)にはその理由が記録されます。また、アップストリームによる認可の拒否は、[アップストリームのエラーメッセージ](/docs/ja/claude-apps-gateway-config#upstream-error-messages)に従ってそのまま渡されます

v2.1.273 より前では、ゲートウェイセッションでの 403 に対して汎用的な `Please run /login` または `Failed to authenticate` メッセージが表示されており、再度サインインしても拒否は解消されませんでした。

<h2 id="network-and-connection-errors">
  ネットワークと接続エラー
</h2>

これらのエラーのほとんどは、Claude Code からのネットワークリクエストが宛先に到達できなかったか、Claude Code と API の間で何かが戻りの応答を変更したことを意味します。アーカイブ書き込みの失敗など、ローカルの原因もある項目については、その本文に記載されています。通常、ローカルネットワーク、プロキシ、ファイアウォール、またはクラウド環境のネットワークポリシーで発生します。

<h3 id="unable-to-connect-to-api">
  Unable to connect to API
</h3>

API への TCP 接続が失敗したか、完了しませんでした。一般的な接続エラーコードについては、メッセージは失敗の種類を示し、括弧内にコードを保持します。

```text theme={null}
Unable to connect to API. Check your internet connection
Connection refused — a firewall or proxy may be blocking it (ConnectionRefused)
Can't reach the API server — check your internet or DNS (ENOTFOUND)
No internet route — check your connection or VPN (EHOSTUNREACH)
Couldn't connect through your proxy (ERR_PROXY_TUNNEL) — the proxy refused the tunnel: check its credentials and that it allows this host
Connection dropped (ECONNRESET)
Request timed out. Check your internet connection and proxy settings
```

Claude Code が認識しないコードは、`Unable to connect to API` の後に括弧内にコードが表示されます。これらのメッセージの一部は複数のコードを表示できます。例えば、`Connection refused` は `ConnectionRefused` または `ECONNREFUSED` を表示でき、`Can't reach the API server` は `ENOTFOUND` または `FailedToOpenSocket` を表示できます。

v2.1.227 より前では、これらの各コード付きメッセージは `Unable to connect to API` の後にコードが続きました。例えば `Unable to connect to API (ECONNREFUSED)` のようにです。

一般的な原因には、インターネットアクセスがない、`api.anthropic.com` をブロックする VPN、または設定されていない必須の企業プロキシが含まれます。

**対応方法：**

* 同じシェルから `curl -I https://api.anthropic.com` を実行して、API ホストに到達できることを確認してください。Windows PowerShell では、組み込みの `Invoke-WebRequest` エイリアスが使用されないように `curl.exe -I https://api.anthropic.com` を使用してください。
* 企業プロキシの背後にいる場合は、Claude Code を起動する前に `HTTPS_PROXY` を設定し、[ネットワーク設定](/docs/ja/network-config) を参照してください。
* LLM ゲートウェイまたはリレーを経由してルーティングする場合は、[`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) をそのアドレスに設定してください。セットアップについては [Claude Code を LLM ゲートウェイに接続する](/docs/ja/llm-gateway-connect) を参照してください。
* ファイアウォールが [ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements) に記載されているホストを許可していることを確認してください。
* 断続的な障害は [自動的に再試行](#automatic-retries) されます。永続的な障害はローカルネットワークの問題を示しています。

`curl` が成功しても Claude Code が失敗する場合、原因は通常、ネットワーク自体ではなく、ランタイムとネットワークの間にあります。

* `ANTHROPIC_BASE_URL` が設定されているかどうかを確認するには、`echo $ANTHROPIC_BASE_URL` を実行するか、PowerShell では `echo $env:ANTHROPIC_BASE_URL` を実行し、[設定ファイル](/docs/ja/settings) の `env` ブロックで確認してください。設定されている場合、Claude Code はモデルリクエストを `api.anthropic.com` ではなくそのアドレスに送信するため、実行されなくなったローカルプロキシまたはゲートウェイを指す残存値は、`curl` が API に到達しても `Connection refused` を生成します。シェルプロファイルまたは設定から削除し、新しいターミナルから Claude Code を起動してください。
* Linux と WSL では、`/etc/resolv.conf` で到達不可能なネームサーバーを確認してください。特に WSL はホストから壊れたリゾルバーを継承できます。
* macOS では、切断またはアンインストールされた VPN クライアントがトンネルインターフェイスまたはルーティングルールを残す可能性があります。`ifconfig` で古い `utun` インターフェイスを確認し、システム設定で VPN のネットワーク拡張機能を削除してください。
* Docker Desktop および同様のコンテナランタイムは、アウトバウンドトラフィックをインターセプトできます。これを除外するために、それらを終了して再試行してください。

<h3 id="unable-to-connect-to-anthropic-services">
  Unable to connect to Anthropic services
</h3>

初回実行セットアップ中に、Claude Code はサインインステップを表示する前に `api.anthropic.com` と `platform.claude.com` に到達できることを確認します。いずれかのチェックが失敗すると、Claude Code は理由を出力して終了します。

```text theme={null}
Unable to connect to Anthropic services
Failed to connect to api.anthropic.com: ECONNREFUSED
Connection to api.anthropic.com timed out after 10 seconds
A proxy is configured via HTTPS_PROXY. Check that it allows connections to the host above.
```

Claude Code は、API リクエストと同じ [プロキシ設定](/docs/ja/network-config) を通じてチェックを送信し、各プローブに 10 秒を与えます。失敗したプローブがプロキシを通過した場合、メッセージは `HTTPS_PROXY` など、そのプロキシを設定した環境変数を名前で示します。v2.1.222 より前では、チェックはタイムアウトなしの異なるプロキシトランスポートを使用していました。`https://` スキーム付きのプロキシ URL の背後では、`Checking connectivity...` で無期限に停止してから失敗する可能性があり、同じプロキシを通じた API リクエストが成功しても失敗していました。

Claude Code は、[管理設定ファイル、MDM ポリシー、またはポリシーヘルパー](/docs/ja/managed-settings) が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、`forceLoginMethod` なしで [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定する場合、このチェックをスキップします。どちらの設定でも、Claude Code は Anthropic のサインイン方法ではなく **Cloud gateway** 画面でサインインステップを開きます。また、マシン上の管理設定ソースが存在するが読み取れない場合も、Claude Code はチェックをスキップします。そのソースがゲートウェイ設定を保持している可能性があるためです。v2.1.247 より前では、Claude Code はこの設定下でもチェックを実行し、Anthropic のエンドポイントに到達できない場合、このエラーで終了しました。

**対応方法：**

* メッセージがプロキシ変数を名前で示している場合は、その値が正しいプロキシを指していることを確認し、ネットワークチームにそのプロキシ経由でメッセージ内のホストへの HTTPS 接続を許可するよう依頼してください。[ネットワーク設定](/docs/ja/network-config) を参照してください。
* [Unable to connect to API](#unable-to-connect-to-api) のチェックを実行してください。そこの `curl` テストとファイアウォールガイダンスはこのチェックにも適用されます。
* ネットワークが開いており、障害が続く場合、Claude Code は [ご利用の国で利用できない](https://www.anthropic.com/supported-countries) 可能性があります。

<h3 id="socket-is-closed">
  Socket is closed
</h3>

`Socket is closed` は、ストリーミング応答を運ぶ接続が、応答がまだ到着している間に閉じられたことを意味します。最も一般的な原因は、Windows 上の企業プロキシが確立されたトンネルを応答の途中でドロップすることです。

応答がどこまで進んだかに応じて、Claude Code はリクエストを再試行するか、Claude が生成したものを保持するか、ターンを終了します。[自動再試行](#automatic-retries) を参照してください。

v2.1.214 より前では、Claude Code はこの障害を再試行せず、ターンは `Socket is closed` を含むエラーで停止しました。

**対応方法：**

* このエラーが表示される場合は、`claude update` で v2.1.214 以降に更新してから、メッセージを再度送信してください。
* 更新後も同じプロキシの背後でターンが失敗し続ける場合は、[Unable to connect to API](#unable-to-connect-to-api) を実行し、[ネットワーク設定](/docs/ja/network-config) でプロキシセットアップを確認してください。

<h3 id="api-returned-an-empty-or-malformed-response">
  API returned an empty or malformed response
</h3>

Claude Code は、失敗したストリーミングリクエストの非ストリーミング再試行が HTTP 成功ステータスを取得しても、本文が Claude API メッセージではない場合、このエラーを表示します。一般的には HTML エラーまたはサインインページ、空の本文、または別の形式の JSON です。プロキシ、ゲートウェイ、またはネットワークサインインページが API の代わりに応答することが通常の原因です。Claude Code はリクエストを再試行せず、ターンはこのエラーで終了します。

```text theme={null}
API returned an empty or malformed response (HTTP 200) — check for a proxy or gateway intercepting the request.
```

その冒頭の後、メッセージは戻ってきたものと失敗したリクエストを報告します。

* `Response:` 句は、コンテンツタイプ、本文の種類（`body is an HTML page` または `empty body` など）、バイト単位のサイズ、およびレスポンスが Anthropic リクエスト ID を運んだかどうかを示します。レスポンスが `nginx` または `cloudflare` などの認識可能なサーバーを名前で示すか、`cf-ray` または `via` などの中間ヘッダーを運ぶ場合、句はそれらもリストします。
* 失敗したストリーミングリクエストの ID と、再試行のきっかけとなった障害を名前で示す文。障害の前にストリームが開いていた場合、到着したストリームイベント数と、いずれかが到着した場合は、試行が失敗したときにストリームが沈黙していた時間も報告します。

v2.1.234 より前では、メッセージは `intercepting the request` の後で終了しました。

v2.1.271 より前では、`text/plain` などの JSON 以外のコンテンツタイプの下で有効な API メッセージを運ぶ返信もこのエラーでターンを終了しました。一部の LLM ゲートウェイは非ストリーミング返信にそのコンテンツタイプを使用します。

**対応方法：**

* `Response:` 句を読んで、どのシステムが応答したかを確認してください。HTML 本文、Anthropic リクエスト ID がない、または `nginx` や `cloudflare` などの名前付きサーバーは、Claude Code と API の間の何かが代わりに応答したことを意味します。
* [LLM ゲートウェイ](/docs/ja/llm-gateway-connect#troubleshoot-gateway-errors) を通じてルーティングする場合は、直接リクエストでルートをテストし、非 API レスポンスを返すホップを修正してください。
* ゲスト Wi-Fi などのサインインページを持つネットワーク上では、ブラウザーでサインインを完了してから再試行してください。
* ゲートウェイを通じた非ストリーミングルートのみが壊れている場合は、[`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK=1`](/docs/ja/env-vars#variables) を設定して、このフォールバックをオフにしてください。ただし、ストリーミングエンドポイント自体が `404` を返す場合は除きます。その場合、Claude Code は引き続きフォールバックします。

<h3 id="streaming-response-ended-before-any-complete-data-was-received">
  Streaming response ended before any complete data was received
</h3>

モデルプロバイダーからのストリーミング応答が使用可能なデータを配信せずに完了したため、Claude Code はターンを完了するためにリクエストをストリーミングなしで再送信しました。Claude Code は警告をセッションごとに 1 回、対話型セッションでのみ表示します。v2.1.239 より前では、Claude Code はストリーミングなしで黙って再試行しました。

```text theme={null}
Streaming response ended before any complete data was received. Retrying without streaming. If this keeps happening, check any proxy or gateway between Claude Code and your model provider.
```

Claude Code は影響を受けた各リクエストを 2 回送信します。空のストリーミング試行と再試行です。通常の原因は、戻りの途中でストリーミングレスポンス本文を消費または変換するプロキシまたはゲートウェイです。

**対応方法：**

* Claude Code とモデルプロバイダーの間のプロキシまたはゲートウェイを設定して、ストリーミングレスポンス本文とそのヘッダーを変更せずに通すようにしてください。
* [Amazon Bedrock](/docs/ja/amazon-bedrock) では、[ゲートウェイまたはプロキシの背後でのストリーミングエラー](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy) を参照して、ヘッダーと本文の要件を確認してください。

<h3 id="bedrock-streaming-response-has-an-unexpected-content-type">
  Bedrock ストリーミング応答に予期しないコンテンツタイプがあります
</h3>

Claude Code と [Amazon Bedrock](/docs/ja/amazon-bedrock) の間のゲートウェイまたはプロキシがストリーミングレスポンス本文またはその `Content-Type` ヘッダーを変換しています。Amazon Bedrock はストリーミング応答を `application/vnd.amazon.eventstream` として配信します。読み取れない本文をデコードするのではなく、Claude Code は異なるコンテンツタイプを報告する成功したストリーミングレスポンスを拒否します。Claude Code はリクエストを再試行しません。

```text theme={null}
Bedrock streaming response has content-type "text/event-stream"; expected "application/vnd.amazon.eventstream". A gateway or proxy between Claude Code and Bedrock is likely transforming the response body — Bedrock's binary event-stream format must be passed through unmodified. Set CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1 to suppress this check while the gateway is being fixed.
```

v2.1.208 より前では、同じ設定ミスは、応答全体がバッファリングされた後、`API Error: Truncated event message received` として表示されました。

**対応方法：**

* ゲートウェイを設定して、`InvokeModelWithResponseStream` レスポンス本文とその `Content-Type` ヘッダーを変更せずに通すようにしてください。ストリームをサーバー送信イベントとして再発行する中間者は一般的な原因です。
* [`CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1`](/docs/ja/env-vars) を設定するとこのエラーが非表示になりますが、Claude Code は書き換えられたヘッダーの下でバイナリ本文をデコードしないため、これらのリクエストはより遅い非ストリーミングパスにフォールバックします。[ゲートウェイまたはプロキシの背後でのストリーミングエラー](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy) を参照してください。

<h3 id="ssl-certificate-errors">
  SSL 証明書エラー
</h3>

ネットワーク上のプロキシまたはセキュリティアプライアンスが TLS トラフィックを独自の証明書でインターセプトしており、Claude Code はそれを信頼していません。

```text theme={null}
Unable to connect to API: SSL certificate verification failed (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). The certificate comes from an authority Claude Code doesn't trust, usually a TLS-inspecting corporate proxy or a gateway signed by a private CA: set NODE_EXTRA_CA_CERTS to that CA bundle, or add it to the system certificate store · see https://code.claude.com/docs/en/network-config
Unable to connect to API: Self-signed certificate detected (SELF_SIGNED_CERT_IN_CHAIN). The certificate comes from an authority Claude Code doesn't trust, usually a TLS-inspecting corporate proxy or a gateway signed by a private CA: set NODE_EXTRA_CA_CERTS to that CA bundle, or add it to the system certificate store · see https://code.claude.com/docs/en/network-config
```

v2.1.273 より前では、両方のメッセージは `Check your proxy or corporate SSL certificates` で終了し、OpenSSL コードや `NODE_EXTRA_CA_CERTS` のヒントはありませんでした。

v2.1.199 以降、証明書検証の失敗は再試行されないため、このエラーは [再試行予算](#automatic-retries) をすべて使い切った後ではなく、最初の試行時に表示されます。以前のバージョンは、表示する前に数分間再試行しました。ハンドシェイクタイムアウトなどの一時的な TLS 条件は、引き続き再試行されます。

`/login` とスタートアップ接続チェック中には、同じ障害が異なるメッセージを生成します。

```text theme={null}
SSL certificate error (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). If you are behind a corporate proxy or TLS-intercepting firewall, set NODE_EXTRA_CA_CERTS to your CA bundle path, or ask IT to allowlist *.anthropic.com. Run `claude doctor` for details.
```

[Amazon Bedrock](/docs/ja/amazon-bedrock) では、Claude Code 自体が AWS に送信するリクエスト（STS および SSO ロール認証情報呼び出し、モデル検出、セットアップウィザードのチェックなど）は、同じ証明書設定に依存しています。[TLS 検査プロキシの背後での証明書エラー](/docs/ja/amazon-bedrock#certificate-errors-behind-a-tls-inspecting-proxy) を参照してください。

**対応方法：**

* 組織の CA バンドルをエクスポートし、`NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem` で Claude Code にそのバンドルを指定してください。
* 完全なセットアップ手順については、[ネットワーク設定](/docs/ja/network-config#custom-ca-certificates) を参照してください。
* `NODE_TLS_REJECT_UNAUTHORIZED=0` を設定しないでください。これは証明書検証を完全に無効にします。

<h3 id="host-not-allowed-in-a-cloud-session">
  クラウドセッションでホストが許可されていません
</h3>

クラウドセッションまたはルーティンからのアウトバウンド HTTP リクエストが環境のネットワークポリシーによってブロックされました。

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

宛先の実際の証明書と一致しない TLS 証明書が表示される場合もあります。クラウドセッションはネットワークポリシーを適用するプロキシを通じてアウトバウンドトラフィックをルーティングするため、一致しない証明書は宛先ではなくプロキシが接続を終端したことを意味します。

これはクライアント側のネットワーク問題ではありません。クラウドセッションと [ルーティン](/docs/ja/routines) は、セッションのネットワークを通じたアウトバウンドトラフィックが [クラウド環境の](/docs/ja/cloud-environments) 許可リストでフィルタリングされるサンドボックス化された VM 内で実行されます。[GitHub 操作](/docs/ja/cloud-environments#github-proxy) と MCP コネクタトラフィックは別のチャネルを使用するため、他のホストがブロックされている間も機能し続けることができます。**Default** 環境は **Trusted** アクセスを使用し、パッケージレジストリ、クラウドプロバイダー API、コンテナレジストリ、および一般的な開発ドメインの [デフォルト許可リスト](/docs/ja/cloud-environments#default-allowed-domains) を許可し、そのパス上の他のドメインをブロックします。

**対応方法：**

これらのステップは、自身の環境の 1 つを変更します。[組織共有環境](/docs/ja/cloud-environments#organization-shared-environments) はセレクターで読み取り専用で開くため、[管理設定](https://claude.ai/admin-settings) の **Cloud environments** ページから Owner にネットワークアクセスを変更するよう依頼してください。

* 環境を編集用に開きます。[ルーティンのフォーム](/docs/ja/routines#environments-and-network-access) から、またはクラウドセッションを開始する [環境セレクター](/docs/ja/cloud-environments#configure-your-environment) から開きます。
* **Edit environment** ダイアログで、**Network access** を **Trusted** から **Custom** に変更し、ブロックされたドメインを **Allowed domains** に追加してください。1 行に 1 つのドメインを入力してください。**Also include default list of common package managers** をチェックして、カスタムドメインと共に [デフォルト許可リスト](/docs/ja/cloud-environments#default-allowed-domains) を保持してください。無制限のアクセスが必要な場合は、代わりに **Full** を選択してください。
* **Save changes** をクリックしてください。次の実行は更新された許可リストを使用します。既に開いているクラウドセッションについては、[ネットワークアクセスの変更が既存セッションに反映されるタイミング](/docs/ja/cloud-environments#network-access) を参照してください。

アクセスレベルとデフォルト許可リストについては、[ネットワークアクセス](/docs/ja/cloud-environments#network-access) を参照してください。ローカル CLI セッションはこのポリシーの影響を受けません。

<h3 id="the-proxy-refused-the-connection">
  The proxy refused the connection
</h3>

Claude が `HTTPS_PROXY` または関連する [プロキシ変数](/docs/ja/network-config#environment-variables) に設定したプロキシを通じて [アーティファクト](/docs/ja/artifacts) を読み取るときに、このメッセージが表示されます。アーティファクトのコンテンツは `*.frame.claudeusercontent.com` から取得されるため、Claude Code は最初にプロキシに `CONNECT` リクエストを送信して、そのホストへのトンネルを開くよう求めます。プロキシが拒否すると、何もホストに到達せず、メッセージにはプロキシの HTTP ステータスが含まれます。

```text theme={null}
artifact content fetch failed (proxy refused the connection: HTTP 407)
artifact content fetch failed (proxy refused the connection: HTTP 403)
the proxy refused the connection to the artifact's content host (HTTP 502)
```

ステータスは `CONNECT` に対するプロキシの応答です。ホストは応答していないため、各ステータスは異なる修正を指しています。

* `HTTP 407`：プロキシは受け取らなかった認証情報を必要としています。[基本認証](/docs/ja/network-config#basic-authentication) が示すように、プロキシ URL に認証情報を入力してください。
* `HTTP 403`：プロキシは `*.frame.claudeusercontent.com` へのトンネリングを拒否しています。プロキシを運用している担当者に、[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements) にリストされているそのホストを許可するよう依頼してください。
* `HTTP 502` などの他のステータス：プロキシはホストに到達できないなど、独自の理由でトンネルを開きませんでした。プロキシのログでステータスを調べてください。
* ステータスの代わりに `unreadable reply`：プロキシアドレスにあるものが HTTP ステータス行で応答しませんでした。アドレスが HTTP プロキシであることを確認してください。

**対応方法：**

* [プロキシ設定](/docs/ja/network-config#proxy-configuration) で説明されているように、プロキシ変数のアドレスと認証情報を確認してから、Claude Code を起動するシェルから自身のプロキシ URL を使用して `curl -x http://proxy.example.com:8080 -I https://api.anthropic.com` を実行してください。Windows PowerShell では、`curl.exe` を実行してください。このプローブが同じように失敗する場合は、まずプロキシセットアップを修正してください。成功する場合、拒否はアーティファクトホストに固有のものです。
* ネットワークで Claude Code がアーティファクトホストに直接到達できる場合は、`.frame.claudeusercontent.com` を [`NO_PROXY`](/docs/ja/network-config#environment-variables) に追加してください。エントリはこの範囲に限定してください。より広い `.claudeusercontent.com` エントリは、[IP 許可リスト](/docs/ja/network-config#organization-ip-allowlists-and-proxy-egress) を持つ組織がプロキシ経由のままにしておく必要がある `bridge.claudeusercontent.com` についてもプロキシをバイパスしてしまいます。

v2.1.238 より前では、Claude Code は拒否されたトンネルを一般的なネットワークエラーとして報告しました。

<h3 id="the-cloud-environments-service-returned-an-empty-or-unexpected-response">
  クラウド環境サービスが空または予期しない応答を返しました
</h3>

Claude Code は、CLI からクラウドセッションを作成するときや [`/remote-env`](/docs/ja/cloud-environments#select-an-environment-from-the-cli) を実行するときなど、複数の時点で [クラウド環境](/docs/ja/cloud-environments) のリストをリクエストします。サーバーの応答を読み取れない場合、次のいずれかのメッセージが表示されます。

```text theme={null}
The cloud environments service returned an empty response (HTTP 200 with no body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 with a non-JSON body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 without a usable environments list). This is usually temporary — try again in a moment.
```

サーバーはリクエストを受け入れましたが、環境リストではない本文で応答しました。空、JSON ではない、またはリストのない JSON です。これは通常、サービス側の障害に伴って発生し、自然に解消します。リストをリクエストしたサーフェスに応じて、Claude Code は `/remote-env` ダイアログの `couldn't list environments:` などのプレフィックスを追加する場合があります。

**対応方法：**

* アクションを再試行してください。Claude Code はアクションのたびにリストを再度リクエストします。
* メッセージが表示され続ける場合は、[status.claude.com](https://status.claude.com) でアクティブなインシデントを確認してください。

v2.1.236 より前では、Claude Code はこれらのメッセージの代わりに生の JavaScript TypeError を表示しました。

<h3 id="couldnt-reconnect-to-your-remote-control-session">
  Couldn't reconnect to your Remote Control session
</h3>

```text theme={null}
Couldn't reconnect to your Remote Control session. Retry, or start a fresh session without --resume.
```

`claude --resume` または `claude --continue` で再開すると、その会話に記録された [Remote Control](/docs/ja/remote-control) セッションに再接続します。このメッセージは、ネットワーク中断やサーバーエラーなど、一時的な可能性のある理由で再接続が失敗したため、Claude Code がリモートセッションがまだ存在するかどうかを確認できないことを意味します。ローカルセッションは Remote Control なしで実行を続けます。

**対応方法：**

* `/remote-control` を実行して接続を再試行してください。
* `claude --remote-control` で新しいセッションを開始して、新しい Remote Control セッションを作成してください。
* 他の Remote Control スタートアップメッセージについては、[Remote Control のトラブルシューティング](/docs/ja/remote-control#troubleshooting) を参照してください。

サーバーが代わりに前のセッションが存在しないと報告した場合、このメッセージは表示されません。Claude Code は、その代わりに新しいセッションを開始するか、[`Previous session is unavailable — run /remote-control to start a new one`](/docs/ja/remote-control#previous-session-is-unavailable) を表示します。

<h3 id="sessions-ended-while-this-machine-was-offline">
  Sessions ended while this machine was offline
</h3>

Claude Code は、マシンが長時間オフラインになり、マシンが提供していた Remote Control 環境をサーバーがクリーンアップした後、[`claude remote-control`](/docs/ja/remote-control#start-a-remote-control-session) を実行しているターミナルにこのメッセージを表示します。その環境のセッションは終了しており、再開することはできません。数値は終了したセッション数です。

```text theme={null}
2 sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.
```

**対応方法：**

* Claude Code がこのメッセージの下に保持された worktree を一覧表示した場合は、そこから未コミットの作業を回収してください。
* `claude remote-control` を実行して新しい環境を開始してください。

<h3 id="couldnt-share-the-transcript">
  Couldn't share the transcript
</h3>

[セッション品質調査](/docs/ja/data-usage#session-quality-surveys) などの調査プロンプトからセッショントランスクリプトの共有に同意すると、Claude Code はそれを Anthropic にアップロードします。サードパーティプロバイダー上、[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway) セッション上、および Anthropic 認証情報が利用できない場合は、代わりにローカルアーカイブを保存します。このメッセージは共有が完了しなかったことを意味します。

```text theme={null}
Couldn't share the transcript.
```

アップロードは 8 MiB の制限内に収まる必要があります。長いセッションでは、Claude Code は共有の一部を段階的に削除します。最初に最後のリクエストのモデル設定、次に構造化された会話とサブエージェントのトランスクリプトを削除し、削減したバージョンを送信できない場合、またはネットワークエラーやサーバーエラーでアップロードが停止した場合に、このメッセージを表示します。Claude Code が代わりにローカルアーカイブを保存する場合、このメッセージはアーカイブを書き込めなかったことを意味します。

**対応方法：**

* `/feedback` を実行して、何が起こったかの説明と共にトランスクリプトを送信してください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。
* 他のリクエストも失敗している場合は、ネットワーク接続を確認し、[Unable to connect to API](#unable-to-connect-to-api) を参照してください。

<h3 id="couldnt-send-feedback">
  Couldn't send feedback
</h3>

[`/feedback`、`/bug`、または `/share` ダイアログ](/docs/ja/commands#all-commands) からレポートを送信し、Anthropic へのアップロードが失敗しました。ダイアログはテキストを保持するため、再試行できます。

```text theme={null}
Couldn't send feedback (couldn't reach the service). If it keeps failing, you can file at https://github.com/anthropics/claude-code/issues instead.
```

プレフィックスの後のテキストは、何が失敗したかを示します。

* **`: not signed in. Run /login, then retry.`**：ダイアログは、開いた時点で Claude Code が Anthropic 認証情報を見つけた場合にのみアップロードを行いますが、送信時には使用可能な認証情報がありませんでした。例えば、その間にこのマシンでサインアウトしたか、ログインを更新できなくなった場合です。
* **括弧内の表記**：`(server returned <status>)` はサービスの応答コードです。`(request timed out)` と `(couldn't reach the service)` はネットワーク障害です。Claude Code が理由を特定できない場合、括弧内の表記はありません。

[フィードバックドラフトキュー](/docs/ja/tools-reference#sendfeedback-tool-behavior) では、同じ障害は代わりに `The draft is still queued. Try again later.` で終了し、ドラフトは次の試行のためにキューに残ります。

**対応方法：**

* サインインしていないことを示す表記の場合は、`/login` を実行して再度送信してください。
* それ以外の場合は、再度送信してください。他のリクエストも失敗している場合は、ネットワーク接続を確認し、[Unable to connect to API](#unable-to-connect-to-api) を参照してください。
* 失敗し続ける場合は、メッセージが示すように [github.com/anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues) でレポートを提出してください。

v2.1.281 より前では、ダイアログを開いている間に Remote Control の **Stop** または緊急のクロスセッションメッセージが到着すると、以降のすべての送信がこのメッセージで失敗しました。これらのバージョンでは、ダイアログを閉じて再度開き、もう一度送信してください。

<h2 id="request-errors">
  リクエストエラー
</h2>

これらのエラーはリクエストの内容に関連しています。ほとんどは API がリクエストを拒否した後に返されます。いくつかはリクエストが送信される前に Claude Code によってローカルで生成されます。

<h3 id="prompt-is-too-long">
  Prompt is too long
</h3>

会話と添付ファイルがモデルのコンテキストウィンドウを超えています。

```text theme={null}
Prompt is too long
```

対話セッションでは、Claude Code はこのエラーを次のように表示します：

```text theme={null}
Context limit reached · /compact or /clear to continue
```

[`DISABLE_COMPACT`](/docs/ja/env-vars) が設定されている場合、この行は `/clear` のみを表示します。下記のコンテキスト圧縮失敗形式などのエラーの長い形式では、`Prompt is too long ·` という表現が保持されます。`-p` 出力とトランスクリプトでは、テキストは `Prompt is too long` のままです。

[ユーザー設定](/docs/ja/settings-reference#autocompactenabled)で自動圧縮をオフにした場合、この行には次のように表示されます：

```text theme={null}
Context limit reached · /compact or /clear to continue · auto-compact is off · /config to turn it on
```

`/config` の **Auto-compact** トグルは、ユーザー設定に `autoCompactEnabled` を書き込みます。このヒントは `/config` の変更が有効になる場合にのみ表示されます。たとえば、[`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) または [`DISABLE_COMPACT`](/docs/ja/env-vars) が自動圧縮をオフにした場合には表示されません。また、プロジェクトまたは管理設定などのより高い優先度のスコープが `autoCompactEnabled` を `false` に設定している場合にも表示されません。v2.1.235 より前では、この行に自動圧縮ヒントは含まれていませんでした。

Amazon Bedrock はこの状態を `Input is too long for requested model.` として報告し、Claude Code は同じ方法で処理します。v2.1.217 より前では、Claude Code は Bedrock の表現を認識しなかったため、自動圧縮はトリガーされず、`/compact` は同じエラーで失敗しました。

[Claude apps gateway](/docs/ja/claude-apps-gateway-config#upstream-error-messages) は、クラウドアップストリームがプロバイダー独自のエラー形式でリクエストを拒否する場合、この状態を `capability_rejected: prompt_too_long` として報告します。Claude Code はトークンを `Prompt is too long` と同じように処理します。v2.1.228 より前では、Claude Code はトークンを認識しなかったため、自動圧縮はトリガーされませんでした。

このターンで自動圧縮が実行され、モデルが利用できないか認証失敗などの基礎となるエラーで失敗した場合、メッセージはセパレータの後にそのエラーを示します：

```text theme={null}
Prompt is too long · automatic compaction failed: <the underlying error>
```

示されたエラーを最初に解決してください。`/compact` は解決するまで同じエラーで失敗します。v2.1.229 より前では、失敗した自動圧縮は原因なしで `Prompt is too long` を表示していました。

このエラーで自動圧縮が実行される場合、通常は最も古いやり取りを要約し、最新のものを保持します。最後の手段として、Claude Code は異なる方法で要約します：

* やり取り全体を要約できない場合、Claude Code は最新のプロンプトをそのまま保持し、その前のすべてを要約します。
* その場合、会話がユーザーのプロンプトで終わらないときは、Claude Code は代わりに会話全体を要約します。

引き継ぐコンテンツにモデルの応答が含まれず、ユーザー自身のテキストが約 1,000 トークン未満である場合（大きすぎる貼り付けの後に送信した短い再試行など）、Claude Code はこの復旧をスキップします。`/clear` を実行して新しく開始してください。v2.1.269 より前では、やり取り全体を要約できない場合は常に圧縮が失敗したため、その状態のセッションはすべてのターンでこのエラーに再度ヒットしました。

単一のやり取りからなる会話には、要約する以前のターンがありません。そのような会話で自動圧縮が実行されるはずだった場合、Claude Code は試行をスキップし、代わりにリクエストを何が占めているかを説明します。API がエラーでトークン数を報告しない場合、メッセージは次のようになります：

```text theme={null}
Prompt is too long · this conversation is a single exchange and cannot be compacted — the request size comes mostly from system prompt, tool definitions, or attachments.
```

API がエラーでトークン数を報告する場合、Claude Code はそれらを会話のサイズの独自の推定値と比較して、リクエストの大部分が何であるかを判断します：会話独自のコンテンツか、あるいは Claude Code が会話とともに送信するシステムプロンプト、ツール定義、添付ファイルコンテンツか。会話独自のコンテンツがリクエストの大部分である場合、メッセージは次のようになります：

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) and this conversation's own content is most of it. A single-exchange conversation cannot be compacted; start with less content (smaller files or pasted text).
```

リクエストの大部分が会話外にある場合、メッセージは次のようになります：

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) but this conversation is only ~<conversation tokens> tokens — the rest is system prompt, tool definitions, and attachment content. A single-exchange conversation cannot be compacted; reduce attached files/tools or start with less context.
```

v2.1.162 より前では、Claude Code は圧縮を試行し、失敗時に単純な `Prompt is too long` を表示していました。

**対応方法：**

* `/compact` を実行して以前のターンを要約し、スペースを解放するか、`/clear` を実行して新しく開始してください。`/compact` が `Not enough messages to compact.` と答える場合、会話は単一のやり取りであり、要約する以前のものがないため、スペースはそのプロンプトと Claude Code がすべてのリクエストで送信するもので占められています。`/clear` を実行し、貼り付けたテキストを少なくするか、より小さな添付ファイルで再送信するか、以下の手順を使用してツール定義とメモリファイルを削減してください
* `/context` を実行して、ウィンドウを消費しているものの内訳を確認してください：システムプロンプト、ツール、メモリファイル、メッセージ
* `/mcp disable <name>` で使用していない MCP サーバーを無効にして、コンテキストからツール定義を削除してください
* 大きな `CLAUDE.md` メモリファイルをトリミングするか、[パススコープルール](/docs/ja/memory#path-specific-rules)に指示を移動して、関連する場合にのみ読み込むようにしてください
* 自動圧縮はデフォルトでオンであり、通常このエラーを防ぎます。`/config` または [`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) でオフにした場合は、オンに戻してください。オフのままにする場合は、ウィンドウが満杯になる前に `/compact` を自分で実行してください。

[コンテキストウィンドウを探索](/docs/ja/context-window)して、コンテキストがどのように満杯になるかのインタラクティブビューを確認してください。

<h3 id="context-exceeds-the-token-limit">
  コンテキストがトークン制限を超えています
</h3>

`/context` は、会話がモデルのコンテキストウィンドウを超えて成長した場合、出力の上部にこの警告を表示します。スペースを解放するまで、リクエストは [`Prompt is too long`](#prompt-is-too-long) で失敗します。対話セッションはそのエラーを `Context limit reached` 行として表示します。

```text theme={null}
Context exceeds the 200k-token limit by 94k tokens — run /compact or /clear to continue.
```

超過した制限が 1M コンテキストモデルの 200K 境界などの圧縮ウィンドウである場合、警告は異なる表現になります。圧縮ウィンドウはモデルのコンテキストウィンドウより小さい場合があるため、それを超えたリクエストでも成功する可能性があります。

```text theme={null}
Context is 94k tokens past the 200k-token compaction window — run /compact to reduce usage.
```

[`DISABLE_COMPACT`](/docs/ja/env-vars) を設定した場合、どちらの形式も `/compact` の代わりに `/clear` を示します。

**対応方法：**

* マルチターン会話では、`/compact` を実行して以前のターンを要約し、スペースを解放してください。代わりに新しく開始するには、`/clear` を実行してください
* 使用量を削減するその他の方法については、[Prompt is too long](#prompt-is-too-long)を参照してください

v2.1.216 より前では、`/context` は 100% を超える使用量を表示し、それが何を意味するか、または復旧方法を説明する警告行がありませんでした。

<h3 id="request-too-large">
  Request too large
</h3>

トークン化前の生のリクエストボディが API の 32MB 制限を超えました。通常は、大きな貼り付けコンテンツ、ツール結果、または添付ファイルが原因です。この制限は [コンテキストウィンドウ](#prompt-is-too-long)とは別です。

```text theme={null}
Request too large (max 32MB). Accumulated images and attachments in the conversation pushed the request over the limit. Run /compact, or double press esc to go back and remove attachments.
```

リクエストが Claude API に直接送信され、API 自体がそれを拒否した場合、Claude Code は会話を測定し、復旧が機能するかどうかによってメッセージの表現を変えます。プロキシ、ゲートウェイ、またはクラウドプロバイダーを経由する場合は、一般的なメッセージが表示されます。測定された形式：

* `Request too large (max 32MB; 20.1MB of about 33.4MB is images or documents).`：画像またはドキュメントによってリクエストが制限を超えました。Claude Code はそれらを削除して再試行します。
* `Request too large for the API's 32MB request limit`：メッセージだけで制限を超えているため、メッセージは `compacting cannot make it fit` と示し、Claude Code は再試行しません。[非対話モード](/docs/ja/headless)では、メッセージは代わりに入力を削減するか、新しいセッションを開始するよう指示します。

v2.1.212 より前では、十分に蓄積された画像を持つ会話は、すべてのターンで `Request too large (max 32MB). Double press esc to go back and try with a smaller file.` で失敗しました。v2.1.229 より前では、Claude Code はすべての拒否に対して添付ファイルに関するアドバイスを表示していました。圧縮が役に立たない場合でも同様です。

**対応方法：**

* メッセージが `compacting cannot make it fit` と示す場合は、Esc キーを 2 回押して大きなコンテンツを追加したターンより前に戻るか、`/clear` を実行して新しく開始してください
* それ以外の場合は、`/compact` を実行します。これにより、蓄積された画像と添付ファイルが削除されます
* 大きなファイルの内容を貼り付けるのではなく、パスで参照してください。Claude はそれらをチャンクで読むことができます
* 画像については、以下の [Image was too large](#image-was-too-large)を参照してください

<h3 id="image-was-too-large">
  Image was too large
</h3>

貼り付けまたは添付された画像が API のサイズまたは寸法制限を超えています。

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

Claude Code は処理できない画像をテキストプレースホルダーに置き換えて再試行するため、後続のメッセージは成功します。v2.1.142 より前のバージョンでは、貼り付けられた画像は会話に残り、後続のすべてのメッセージで同じエラーを繰り返す可能性がありました。これらのバージョンで復旧するには、Esc キーを 2 回押して、画像が追加されたターンより前に戻ってください。

**対応方法：**

* 貼り付ける前に画像をリサイズしてください。API は単一の画像で最長辺 8000 ピクセルまで、コンテキストに 20 枚を超える画像がある場合は 3000 ピクセルまでの画像を受け入れます。
* 全画面ではなく、関連する領域に絞ったスクリーンショットを撮ってください

<h3 id="unable-to-resize-image">
  Unable to resize image
</h3>

Claude Code は、API に送信する前に添付画像をダウンスケールできませんでした。

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
Unable to resize image — it is a CMYK JPEG, which Claude Code cannot decode, and at …px it is over the 2000x2000px limit, so it cannot be sent. Re-save it as an RGB PNG or JPEG and try again.
Unable to resize image — it is an animated WebP whose first frame Claude Code cannot decode, and at …px it is over the 2000x2000px limit, so it cannot be sent. Save its first frame as a PNG or JPEG and try again.
Unable to resize image — its pixels could not be decoded (the file may be damaged, or use an encoding Claude Code cannot read), and it is over the … API limit (… raw, … base64), so it cannot be sent. Re-save it as a PNG or JPEG and try again.
```

Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、画像をデコードまたはリサイズして API 制限内に収めることができなかったことを意味します。

**対応方法：**

* メッセージが画像を変換するよう求める場合は、PNG、JPEG、GIF、または WebP に変換して再度添付してください。Claude Code はファイルヘッダーからこれらの形式の寸法を確認でき、画像をデコードする必要はありません。
* メッセージが寸法またはサイズ制限を報告する場合は、その制限を下回るように画像をリサイズまたは再圧縮してから添付してください。
* メッセージが CMYK JPEG、アニメーション WebP、または破損している可能性のあるファイルなどの原因を示す場合は、メッセージが提案する形式で画像を再保存して再度添付してください。

<h3 id="pdf-errors">
  PDF エラー
</h3>

添付した PDF を処理できませんでした。メッセージはここに非対話形式で表示されます。対話セッションでは、代わりに Esc キーを 2 回押して再試行するよう促します。

```text theme={null}
PDF too large (max 100 pages, 20MB). Try reading the file a different way (e.g., extract text with pdftotext).
PDF is password protected. Try using a CLI tool to extract or convert the PDF.
The PDF file was not valid. Try converting it to text first (e.g., pdftotext).
```

**対応方法：**

* 大きすぎる PDF については、ファイル全体を添付するのではなく、Read ツールでページ範囲を読むよう Claude に依頼するか、`pdftotext` などのツールでテキストを抽出して、出力ファイルをパスで参照してください
* 保護されているか無効な PDF については、パスワードを削除するか、ソースアプリケーションからファイルを再度エクスポートしてから再試行してください

Claude が Read ツールで PDF からページ範囲を読むとき、読み取りは異なるメッセージで失敗する可能性があります：

```text theme={null}
pdftoppm is not installed. Install poppler-utils (e.g. `brew install poppler` or `apt-get install poppler-utils`) to enable PDF page rendering.
```

ページ範囲の読み取りは `pdftoppm` でページをレンダリングします。メッセージが提供するコマンドで poppler-utils をインストールするか、他のプラットフォームでは `pdftoppm` を `PATH` に配置する poppler ビルドをインストールしてください。どの PDF がページ範囲で読まれるかについては、[Read ツールの動作](/docs/ja/tools-reference#read-tool-behavior)を参照してください。

<h3 id="extra-inputs-are-not-permitted">
  Extra inputs are not permitted
</h3>

Claude Code と API の間のプロキシまたは LLM ゲートウェイが `anthropic-beta` リクエストヘッダーを削除したため、API はそれに依存するフィールドを拒否しました。

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
```

Claude Code は `context_management` などのベータ専用フィールドを、それらを有効にする `anthropic-beta` ヘッダーとともに送信します。ゲートウェイがボディを転送してもヘッダーを削除すると、API は認識できないフィールドを受け取ることになります。

**対応方法：**

* `anthropic-beta` ヘッダーを転送するようにゲートウェイを設定してください。ゲートウェイが転送する必要があるものについては、[機能パススルー](/docs/ja/llm-gateway-protocol#feature-pass-through)を参照してください。
* フォールバックとして、起動前に [`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/docs/ja/env-vars) を設定してください。正確なスコープについては [プリリリース機能を無効にする](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)で説明しています。

<h3 id="tool-input-schema-is-invalid">
  ツール入力スキーマが無効です
</h3>

リクエスト内のツールが、API の JSON Schema 検証に失敗する `input_schema` を宣言したため、API はリクエスト全体を拒否しました。`tools.` の後の番号は、検索可能な名前ではなく、リクエストのツールリスト内の失敗したツールの位置です。

```text theme={null}
API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid
API Error: 400 ... tools.N.custom.input_schema.properties: Property keys should match pattern '^[a-zA-Z0-9_.-]{1,64}$'
```

最初の形式は、スキーマが有効な JSON Schema draft 2020-12 ではないことを意味します。2 番目は、トップレベルのプロパティ名がメッセージが引用するパターンと一致しないことを意味します。

Claude Code はサーバーのツールを読み込む際に [この検証に失敗する入力スキーマを持つ MCP ツールを除外](/docs/ja/mcp#tools-with-invalid-input-schemas)するため、リクエストには通常そのようなツールは含まれません。

[フラグ取得がオフになっているデプロイ](/docs/ja/env-vars#features-that-need-feature-flag-fetching)、またはフラグが一度も届いていないマシンでは、Claude Code はどのツールが拒否されるかをサーバーのログに記録しますが、そのまま送信するため、このエラーが発生する可能性があります。

このエラーは、`$schema` で draft 2020-12 以外の JSON Schema 方言を宣言するスキーマを持つツールでも発生する可能性があります。Claude Code はこれらのスキーマを JSON Schema メタスキーマに対してチェックしませんが、トップレベルのプロパティ名チェックは引き続き適用されます。

v2.1.216 より前では、どのデプロイでも除外チェックは実行されていませんでした。

**対応方法：**

* Claude Code バージョンが v2.1.216 より前の場合は、`claude update` を実行してください。
* 無効なスキーマを宣言する MCP サーバーを削除するか、[無効にしてください](/docs/ja/mcp#disable-a-server-without-removing-it)。エラーはツールを位置でのみ示します。v2.1.216 以降では、各サーバーのログで、入力スキーマが拒否されるツールを示す行を確認してください。どのログにもそれが示されていない場合は、サーバーを 1 つずつ無効にしてください。
* サーバーを保守している場合は、ツールの `input_schema` を修正してください。スキーマは有効な JSON Schema である必要があり、トップレベルのプロパティ名は 1 ～ 64 文字で、ASCII 文字と数字、`_`、`.`、`-` のみを使用する必要があります。[無効な入力スキーマを持つツール](/docs/ja/mcp#tools-with-invalid-input-schemas)を参照してください。

<h3 id="tool-use-name-over-200-characters">
  tool\_use.name が 200 文字を超えています
</h3>

会話履歴内のツール呼び出しが、API がリクエストで受け入れる 200 文字の制限を超える名前を含んでいます：

```text theme={null}
API Error: 400 ... tool_use.name: String should have at most 200 characters
```

Claude Code は、応答が到着したときと保存された会話を読み込むときに、そのような名前を 200 文字に切り詰めるため、呼び出しは [`No such tool available`](#no-such-tool-available) ツールエラーで失敗し、会話はこの API エラーなしで続行されます。

**対応方法：**

* `claude update` を実行してから、会話を再開してください。更新されたバージョンはトランスクリプトを読み込むときに長すぎる名前を修復するため、スタックしていた会話が再度機能します。

v2.1.281 より前では、長すぎる名前は履歴に残り、API は `/compact` や `--resume` を含む会話を再送信するすべてのリクエストを拒否したため、このエラーが繰り返され、会話はスタックしました。

<h3 id="theres-an-issue-with-the-selected-model">
  There's an issue with the selected model
</h3>

設定されたモデル名が認識されなかったか、アカウントがそれへのアクセス権を持っていません。v2.1.160 の時点で、末尾のヒント（ここでは対話形式で表示）はサーフェスによって異なります。

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to pick a different model.
```

**対応方法：**

* **対話 CLI**：`/model` を実行して、アカウントで利用可能なモデルから選択してください。
* **非対話モード（`-p`）**：有効なエイリアスまたは ID で `--model` を渡すか、[`ANTHROPIC_MODEL`](/docs/ja/env-vars) を設定してください。このサーフェスではエラーテキストに `Run --model` が表示されます。
* **Agent SDK**：モデルはプログラムで設定されるため、エラーテキストはヒントを省略します。TypeScript で [`Options` の `model`](/docs/ja/agent-sdk/typescript#options) を設定するか、Python で [`ClaudeAgentOptions(model=...)`](/docs/ja/agent-sdk/python#claudeagentoptions) を設定し、構造化された `model_not_found` エラーを処理して、独自の再試行またはモデルピッカーを表示してください。
* 完全なバージョン付き ID ではなく、`sonnet` や `opus` などのエイリアスを使用してください。エイリアスは保守されたデフォルトに解決されるため、古くなりません。[モデル設定](/docs/ja/model-config)を参照してください。
* 間違ったモデルが CLI で戻り続ける場合は、古い ID がどこかに設定されています。[優先順位順](/docs/ja/model-config#setting-your-model)でモデルを設定できる場所を確認し、古い値を削除してください。
* Claude Code は期限切れの claude.ai ログインを、このエラーではなく [ログイン期限切れ](#login-expired)として報告します。v2.1.206 より前では、更新できなくなった期限切れのログインはすべてのモデルでこのエラーにより失敗しました。古いバージョンでこれが表示される場合は、`/login` を実行してください。
* Google Cloud の Agent Platform デプロイについては、[Google Cloud の Agent Platform トラブルシューティング](/docs/ja/google-vertex-ai#troubleshooting)を参照してください。

<h3 id="model-is-not-a-recognized-model-id">
  Model is not a recognized model id
</h3>

モデルの切り替えに渡した文字列は、Claude Code がモデルとして使用できるものではないため、リクエストを送信せずに切り替えを拒否し、セッションは現在のモデルを保持します。[Agent SDK](/docs/ja/agent-sdk/typescript) の `setModel()` メソッドでモデルを設定した場合、[Desktop app](/docs/ja/desktop) など Claude Code CLI を代わりに実行するアプリがモデルを設定した場合、または [Remote Control](/docs/ja/remote-control) を通じて接続されたデバイスからモデルを選択した場合に、このエラーが発生する可能性があります。v2.1.200 より前では、Claude Code は文字列を保存し、次のリクエストで [There's an issue with the selected model](#theres-an-issue-with-the-selected-model)として失敗しました。

```text theme={null}
Model "Sonnet5" is not a recognized model id. Did you mean 'claude-sonnet-5'?
```

この例では、アプリは表示名 `Sonnet 5` を送信し、メッセージはそれをスペースなしで繰り返しています。末尾のヒントは、最も近いエイリアスまたはモデル ID を示します。十分に近いものがない場合は、代わりに `Run /model to see available models.` と表示されます。[Desktop app](/docs/ja/desktop) が起動するセッションでは、一致なしの場合のヒントは `Switch to a different model.` と表示されます。

Agent SDK または Anthropic API 上のアプリを通じて切り替える場合、表示名や空の文字列など、モデル ID になり得ない文字列のみがこのエラーになります。

Remote Control デバイスからモデルを選択する場合、Claude Code はローカルで文字列をチェックします。モデルエイリアス、Claude Code が一覧表示するモデルまたはユーザーが設定したモデル、`claude-` で始まる ID のいずれでもない文字列は、`claud-sonnet-5` などのタイプミスされた ID を含めて、このエラーになります。v2.1.260 より前では、このチェックは Remote Control での選択を対象としていなかったため、認識されない文字列が適用され、次のリクエストで失敗しました。

**対応方法：**

* 引数なしで `/model` を実行してピッカーを開き、アカウントで利用可能なモデルから選択してから、そこに表示されるエイリアスまたは ID を渡してください
* 新しい Claude Code バージョンでのみサポートされるエイリアスを使用した場合は、`claude update` を実行するか、代わりにモデルの完全な ID を渡してください。サーバーはそのモデルに最小 Claude Code バージョンを要求する場合があります。[Claude Code does not support this model](#claude-code-does-not-support-this-model)を参照してください。
* v2.1.200 より前に保存されたモデルはこのチェックで修復されません。古い値が戻り続ける場合は、[モデルの設定](/docs/ja/model-config#setting-your-model)に記載されている場所から削除してください。
* Anthropic API 以外のプロバイダー、またはゲートウェイやカスタム `ANTHROPIC_BASE_URL` の背後では、空の文字列のみがこのエラーになります。Claude Code は、すべてのプロバイダーでリクエスト時に [認識されないモデルの診断行](#unrecognized-model-id-on-a-request)を書き込むことがあります。

<h3 id="model-not-found">
  Model not found
</h3>

モデルを名前で切り替えましたが、Claude Code はその名前のモデルが存在することを確認できませんでした。名前が [モデルエイリアス](/docs/ja/model-config#model-aliases)でも Claude Code がローカルで受け入れる別の表記でもない場合、Claude Code は最小限の API リクエストでそれを検証し、このエラーは通常、API エンドポイントの応答です。`/model <name>` では、スペースを含むものなど、そもそもモデル ID になり得ない名前も同じメッセージになります。

```text theme={null}
Model 'claude-opus-9' not found
```

プロバイダー固有のモデル ID を持つプロバイダーでは、メッセージはフォールバックモデルのプロバイダーの ID を示す `Try '...' instead` 提案を追加する場合があります。

**対応方法：**

* 引数なしで `/model` を実行し、アカウントで利用可能なモデルから選択するか、`sonnet` などの [モデルエイリアス](/docs/ja/model-config#model-aliases)を使用してください。これは保守されたデフォルトに解決されます
* 完全な ID を入力した場合は、プロバイダーのモデルカタログと照合してください。新しくリリースされたモデルは、プロバイダーまたはリージョンが提供する前に Anthropic API で利用可能になる場合があります。
* Agent SDK では、`setModel()` はこのメッセージで失敗し、セッションは前のモデルで実行し続けます。TypeScript SDK では、[`supportedModels()`](/docs/ja/agent-sdk/typescript#query-object)を呼び出して、切り替えることができるモデルを一覧表示してください。
* v2.1.265 より前では、`/model` は `opusplan[1m]` エイリアス表記もこのエラーで拒否しました。これらのバージョンでは、Claude Code を更新するか、代わりに [設定](/docs/ja/model-config#setting-your-model)または `--model` でモデルを設定してください。

<h3 id="couldnt-confirm-model-with-the-api">
  Couldn't confirm model with the API
</h3>

[Agent SDK](/docs/ja/agent-sdk/typescript) の `setModel()` メソッド、または [Desktop app](/docs/ja/desktop) など Claude Code CLI を代わりに実行するアプリを通じてモデルを切り替えましたが、モデル ID を API エンドポイントで確認するリクエストが 5 秒以内に応答を得られませんでした。セッションは現在のモデルを保持します。

```text theme={null}
Couldn't confirm model "claude-sonnet-5" with the API. Try again, or run /model to see available models.
```

[Desktop app](/docs/ja/desktop) が起動するセッションでは、メッセージは `Try again.` で終わります。

**対応方法：**

* モデルを再度切り替えてください
* 切り替えが失敗し続ける場合は、Claude Code が API エンドポイントに到達できることを確認してください。[ネットワークと接続エラー](#network-and-connection-errors)を参照してください

<h3 id="api-error-model-not-changed">
  選択したモデルを確認するときの API エラー
</h3>

`/model <name>` でモデルを選択したか、セッションに接続されたアプリが切り替えを要求しました。API は、モデルを検証するために Claude Code が送信する最小限のリクエストを、レート制限やサーバーエラーなど、独自のエントリを持たない理由で拒否しました。セッションは現在のモデルを保持し、メッセージの末尾にそのことが示されます：

```text theme={null}
API error: 429 <the server's explanation> · model not changed
```

メッセージの中央は HTTP ステータスとサーバー独自の説明です。

**対応方法：**

* サーバーの説明に対応してください。レート制限または 5xx ステータスの場合は、待機してモデルを再度選択してください
* 独自の表現を持つ拒否は、[Model not found](#model-not-found)や [Model is restricted by your organization's settings](#model-is-restricted-by-your-organizations-settings)などの周囲のエントリで説明しています

<h3 id="claude-opus-is-not-available-with-the-claude-pro-plan">
  Claude Opus is not available with the Claude Pro plan
</h3>

アクティブなサブスクリプションプランには、選択したモデルが含まれていません。

```text theme={null}
Claude Opus is not available with the Claude Pro plan. If you have updated your subscription plan recently, run /logout and /login for the plan to take effect.
```

Claude Desktop アプリが実行するセッションでは、メッセージはコマンドを示すのではなく、`sign out and sign in again` と表示します。

**対応方法：**

* `/model` を実行し、プランに含まれるモデルを選択してください
* 最近プランをアップグレードしてもこれが表示される場合は、`/logout` を実行してから `/login` を実行してください。保存されたトークンはサインイン時のプランを反映するため、claude.ai でアップグレードしても、再認証するまで既存のセッションで有効になりません。
* 各プランに含まれるモデルについては、[claude.com/pricing](https://claude.com/pricing)を参照してください

<h3 id="claude-code-does-not-support-this-model">
  Claude Code does not support this model
</h3>

Claude Code バージョンが必要な最小値を下回っているため、API は 400 でリクエストを拒否しました。選択したモデルが新しいバージョンを必要としている（サーバーはモデルごとにチェックします）か、組織のポリシーが新しいバージョンを必要としています。400 にはエラーコード `claude_code_version_too_old` が含まれ、メッセージはどの最小値が適用されるかを示します。

```text theme={null}
API Error: 400 Claude Code 2.1.219 does not support this model; version 2.1.255 or newer is required. Run 'claude update', or update the Claude desktop app, then try again.
```

組織ポリシーの表現は次のとおりです：

```text theme={null}
API Error: 400 Claude Code 2.1.240 is older than the minimum version required by your organization's policy. Run 'claude update', or update the Claude desktop app, to continue.
```

API がチェックするバージョンは、リクエストを行った Claude Code バイナリが報告するバージョンです。

**対応方法：**

そのバイナリを更新してから、新しいセッションを開始してください。[セルフホスト環境](/docs/ja/self-hosted-environments-deploy#pin-the-version)を除き、更新方法はバイナリの入手元によって決まります：

| リクエストを行ったバイナリ | 更新方法 |
| :- | :- |
| インストールした Claude Code | `claude update` を実行 |
| Claude デスクトップアプリ | アプリを更新 |
| [VS Code 拡張機能](/docs/ja/vs-code)がバンドルするバイナリ | 拡張機能を更新 |
| Agent SDK パッケージがバンドルするバイナリ | [SDK パッケージをアップグレード](/docs/ja/agent-sdk/hosting#runtime-dependencies)してから、アプリケーションを再起動します。[コンパイルされた単一ファイル実行可能ファイル](/docs/ja/agent-sdk/typescript#compile-to-a-single-executable)では、それを再ビルドします |

* [stable リリースチャネル](/docs/ja/setup#configure-release-channel)で `claude update` を実行した場合、最新の stable リリースより先には進みません。そのリリースは必要な最小バージョンを下回っている可能性があります。latest チャネルに移行してから、再度更新してください。組織が [管理設定](/docs/ja/managed-settings)を通じてチャネルまたはバージョンを固定している場合は、管理者に変更を依頼してください
* モデルごとの表現については、別のモデルに切り替えることで現在のセッションで作業を続けることができます。CLI で `/model` を実行するか、ストリーミング入力モードで TypeScript SDK の `Query` オブジェクトの [`setModel()`](/docs/ja/agent-sdk/typescript#query-object)を呼び出すか、Python SDK の `ClaudeSDKClient` の [`set_model()`](/docs/ja/agent-sdk/python#claudesdkclient)を呼び出してください
* 組織ポリシーの表現については、続行する前に更新してください

<h3 id="model-is-restricted-by-your-organizations-settings">
  Model is restricted by your organization's settings
</h3>

組織の管理者が claude.ai 管理コンソールでこのモデルを無効にしたか、管理設定が [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストまたは [`deniedModels`](/docs/ja/model-config#block-specific-models-or-versions) リストを通じてそれを除外しました。`--model`、`ANTHROPIC_MODEL`、または `model` 設定が制限されたモデルを指定した場合、通知は起動時に表示され、セッションが代わりに使用するモデルを示します。管理設定によってセッションで使用できる許可されたモデルが残らない場合は、[管理設定がデフォルトモデルをブロック](#managed-settings-block-the-default-model)を参照してください。管理者が claude.ai 管理コンソールでセッションが実行されているモデルを無効にした後、置換通知はセッション中に表示される場合もあります。

```text theme={null}
Model "claude-opus-4-8" is restricted by your organization's settings. Using claude-sonnet-4-6 instead.
```

制限されたモデルに対して `/model <name>` を入力すると拒否され、セッションは現在のモデルを保持します。管理コンソールで無効にされたモデルの場合、拒否は `Model '<name>' is restricted by your organization's settings. Run /model to choose a different model.` と表示されます。管理設定が除外するモデルの場合、`Model '<name>' is not available. Your organization restricts model selection.` と表示されます。

エージェント、スキル、またはコマンド名で始まる通知は、制限が [サブエージェントの要求されたモデル](/docs/ja/sub-agents#choose-a-model)に適用されたことを意味します：サブエージェントは置換モデルで実行され、セッションのモデルは変更されません。v2.1.223 より前では、Claude Code は Agent ツールで起動されたサブエージェントに対してのみ通知を表示していました。

Claude Code は、モデルファミリーエイリアス（`opus`、`sonnet`、`haiku`、`fable` のいずれか）を、そのファミリーの最新バージョンではなく、そのファミリーへのリクエストとして扱います。Anthropic API および [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)では、制限されたファミリーエイリアスは、組織の設定が許可するファミリーの最新バージョンに解決され、置換通知がそのバージョンを示します。Claude Code が `/model <alias>` を拒否するのは、ファミリーのすべてのバージョンが制限されている場合のみです。v2.1.205 より前では、ファミリーエイリアスは、同じファミリーの古いバージョンが許可されている場合でも、最新バージョンのみに基づいて置換または拒否されていました。

**対応方法：**

* `/model` を実行して、組織が許可するモデルから選択してください。制限されたモデルはピッカーから非表示になります。
* 制限されたモデルが `--model`、`ANTHROPIC_MODEL`、設定ファイルの `model` フィールド、または [サブエージェント](/docs/ja/sub-agents#choose-a-model)、スキル、コマンドの `model` フロントマターに設定されている場合は、その値を削除または更新して、通知が再度表示されないようにしてください
* 制限されたモデルへのアクセスが必要な場合は、組織の管理者に有効にするよう依頼してください。[組織のモデル制限](/docs/ja/model-config#organization-model-restrictions)を参照してください。

<h3 id="cant-switch-to-the-default-model">
  Can't switch to the default model
</h3>

Default モデルを選択しました（たとえば、`/model` ピッカーで Default 行を選択するか、`/model default` を入力した場合）。Claude Code は切り替えを拒否したため、セッションは現在のモデルを保持します。

```text theme={null}
Can't switch to the default model: your organization's managed settings block it (claude-opus-4-6) in "deniedModels", and none of the models they allow can be used as the default instead. Ask your administrator to update "deniedModels" or "availableModels".
```

コロンの後の表現は、切り替えをブロックしたものを示します：

* **`your organization's managed settings block it ... in "deniedModels"`**：管理拒否リストが、Default オプションが解決するモデルをブロックしています
* **`your organization allows only the models listed in "availableModels"`**：[`availableModelsMatch`](/docs/ja/settings-reference#availablemodelsmatch) が `"exact"` に設定された管理 [`availableModels`](/docs/ja/model-config#restrict-model-selection) 許可リストが、Default オプションが解決するモデルを含んでいません
* **`Claude Code couldn't read your organization's managed settings to check which models they allow`**：[管理設定](/docs/ja/managed-settings)を読み取ることができず、Claude Code は未確認のまま切り替えを適用するのではなく拒否します

**対応方法：**

* [`deniedModels`](/docs/ja/settings-reference#deniedmodels) と `availableModels` の表現については、`/model` を実行して、組織が許可するモデルを名前で選択してください
* メッセージが示す管理設定を更新するよう管理者に依頼してください
* `couldn't read` の表現については、Claude Code を再起動してください。それでも続く場合は、管理者に管理設定を確認するよう依頼してください

代わりに、これらの管理設定の下でセッションが `Claude Code can't start` メッセージで起動に失敗する場合は、[管理設定がデフォルトモデルをブロック](#managed-settings-block-the-default-model)を参照してください。

<h3 id="model-switch-was-blocked-by-a-premodelswitch-hook">
  Model switch was blocked by a PreModelSwitch hook
</h3>

[PreModelSwitch フック](/docs/ja/hooks#premodelswitch)が、ユーザーまたはクライアントが要求したモデルの切り替えを承認しなかったため、セッションは現在のモデルを保持します。切り替えが入力したコマンドではなく、[Agent SDK](/docs/ja/agent-sdk/overview) ホストまたは [Remote Control](/docs/ja/remote-control) から来た場合、メッセージは `Model switch blocked by a PreModelSwitch hook` と表示され、ターゲットモデルは示されません。

```text theme={null}
Model switch to Opus 4.6 was blocked by a PreModelSwitch hook: Opus 4.6 is retired for this project. Use a newer model.
```

コロンの後の理由は、何が切り替えを拒否したかを示します：

* **フックが書いた理由**：PreModelSwitch フックが [切り替えを拒否したか確認を求めた](/docs/ja/hooks#premodelswitch-decision-control)際に、その理由を提供しました。求められていることに対応するか、フックが許可するモデルを選択してください。
* **`PreModelSwitch hook <name> did not respond before its timeout`**：[タイムアウト](/docs/ja/hooks#timeouts)までに応答しないフックは切り替えをブロックします。ハングしているコマンドを修正するか、そのフックの `timeout` を上げてから、再度切り替えてください。
* **`confirmation required, and this session cannot ask`**：フックが理由なしで `ask` と答えましたが、制御リクエストには確認プロンプトを表示する方法がありません。[`-p` 実行](/docs/ja/headless)での `/model` コマンドは、同じ状態を理由の後に `(run /model interactively to confirm)` を付けて報告します。対話セッションから切り替えを行うか、このモデルに対するフックの決定を変更してください。
* **`so organization-managed PreModelSwitch hooks could not be checked`**：Claude Code は、組織の [管理プラグイン](/docs/ja/settings-reference#enabledplugins)が提供する PreModelSwitch フックを判断できませんでした（たとえば、管理プラグインの読み込みに失敗した場合）。それらのフックのいずれかが切り替えをブロックする可能性があるため、Claude Code は未確認のまま切り替えを適用するのではなく拒否します。理由の冒頭に失敗したものが示されます。Claude Code は切り替えを試みるたびに再チェックするため、その後解消された失敗はブロックしなくなります。失敗し続ける場合は、`claude --debug` を実行して再度切り替え、詳細をキャプチャしてから、プラグインを修正するか、管理者に修正を依頼してください。
* **`a PreModelSwitch hook failed before answering`** または **`PreModelSwitch hooks were cancelled (the control stream closed) before answering`**：フックの実行が判定なしで終了し、Claude Code はそれを承認として扱いません。`claude --debug` を実行して失敗したものを確認してから、再度切り替えてください。

v2.1.260 より前では、管理プラグインによる拒否は `plugin hooks could not be loaded, so PreModelSwitch hooks could not be checked; see the debug log` と表示されていました。Claude Code はプラグインの読み込みを 1 回再試行した後、組織が管理プラグインを持っていない場合でも、セッション内のそれ以降の切り替えを拒否していました。これらのバージョンでは、セッションを再起動してプラグインの読み込みを再度実行してください。

<h3 id="couldnt-save-it-as-your-default">
  Couldn't save it as your default
</h3>

デフォルトとして保存するモデルを選択しましたが（たとえば、`/model <name>` または `/model` ピッカーでの `Enter`）、Claude Code は選択をユーザー設定ファイル `~/.claude/settings.json` に書き込むことができませんでした。切り替え自体は適用されたため、現在のセッションは選択したモデルで実行されますが、デフォルトは変更されず、次のセッションは古い値で開始されます。

```text theme={null}
Set model to Fable 5.1 for this session only · couldn't save it as your default: ~/.claude/settings.json can't be written (EROFS)
```

ファイルパスの後の理由は失敗したものを示します：

* **`can't be written (<code>)`**：書き込みが括弧内のオペレーティングシステムエラーコードで失敗しました。たとえば、ファイルまたはそのリンク先のファイルが書き込みを拒否するファイルシステム上にある場合は `EROFS` になります。ファイルを書き込み可能にして再度切り替えてください。別のツールがファイルを生成している場合は、代わりにそのツールで `model` キーを設定してください。[Claude Code で行った変更が新しいセッションで失われる](/docs/ja/settings#a-change-you-made-in-claude-code-is-lost-in-new-sessions)を参照してください。
* **`isn't valid JSON`**：ディスク上のファイルが解析できず、Claude Code は読み戻せないコンテンツを上書きするのではなく、ファイルをそのままにします。構文エラーを修正してから再度切り替えてください。[壊れた設定ファイルを修正する](/docs/ja/settings#fix-a-broken-settings-file)を参照してください。

`couldn't confirm it was saved as your default (~/.claude/settings.json is still being written)` で終わる通知は、3 秒経過しても書き込みが完了していないことを意味します。書き込みはバックグラウンドで続行されるため、デフォルトが保存される可能性はあります。次のセッションがどのモデルで開始されるかを確認するか、`/model <name>` を再度実行してください。

v2.1.265 より前では、書き込みが失敗した場合でも、通知はモデルが `saved as your default for new sessions` であると表示していました。

<h3 id="advisor-is-less-capable-than-the-current-main-model">
  アドバイザーが現在のメインモデルより能力が低いです
</h3>

[アドバイザーモデル](/docs/ja/advisor)がセッションのメインモデルより下位にランク付けされているため、Claude Code は選択を保持しますが、メインモデルのリクエストにアドバイザーを付加しません。

```text theme={null}
Advisor set to Opus 4.8
Note: Opus 4.8 is less capable than the current main model (Sonnet 5.5), so the advisor will not activate. Choose a more capable advisor, or switch to a smaller main model.
```

同じ状態を報告する他のメッセージ：

* 対話セッションでは、`Advisor will not activate on the main model (advisor is less capable); subagents may still use it and may use more tokens · /advisor` という通知が表示されます。
* `--advisor` フラグを付けて起動した場合は、`"<advisor>" cannot advise "<main model>" (the advisor must be at least as capable as the main model). The advisor will not be used for the main model.` という警告が表示され、セッションはそのまま開始されます。

**対応方法：**

* より上位のアドバイザーか、より下位のメインモデルを選択してください。[アドバイザーモデルを選択する](/docs/ja/advisor#choose-an-advisor-model)では、ランキングと各メインモデルで受け入れられるアドバイザーを一覧で示しています。
* アドバイザーがモデルに助言できる [サブエージェント](/docs/ja/sub-agents)で引き続き使用したい場合は、アドバイザーを設定したままにしてください

v2.1.287 より前では、Claude Code はいくつかの組み合わせを異なる方法でランク付けしていました。Opus 4.7 または Opus 4.8 のメインモデルに Sonnet 5.5 のアドバイザーを組み合わせた場合にこの注記を表示していましたが、この組み合わせは現在受け入れられます。また、現在この注記が表示される一部のアドバイザー（Sonnet 5.5 のメインモデルに対する Opus 4.8 のアドバイザーなど）を付加していました。

<h3 id="thinking-type-enabled-is-not-supported-for-this-model">
  thinking.type.enabled is not supported for this model
</h3>

Claude Code のバージョンが選択したモデルの最小バージョンより古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**対応方法：**

* `claude update` を実行して Claude Code を再起動してください。Opus 4.7 には v2.1.111 以降が必要です。Opus 4.8 には v2.1.154 以降が必要です。Sonnet 5 には v2.1.197 以降が必要です。Opus 5 には v2.1.219 以降が必要です。Opus 5.5 には v2.1.280 以降が必要です。Sonnet 5.5 には v2.1.284 以降が必要です
* [stable リリースチャネル](/docs/ja/setup#configure-release-channel)では、更新しても最新の stable リリースより先には進まず、そのリリースはこれらのバージョンより古い可能性があります。latest チャネルに移行してから更新してください
* アップグレードできない場合は、`/model` を実行して代わりに Opus 4.6 または Sonnet 4.6 を選択してください
* [Agent SDK](/docs/ja/agent-sdk/overview) でこれに遭遇した場合は、代わりに SDK パッケージをアップグレードしてください。Opus 4.8 には TypeScript SDK v0.3.154 以降と Python SDK v0.2.88 以降が必要です。Sonnet 5 には TypeScript SDK v0.3.197 以降が必要です。Opus 5 には TypeScript SDK v0.3.219 以降が必要です。Opus 5.5 には TypeScript SDK v0.3.280 以降が必要です。Sonnet 5.5 には TypeScript SDK v0.3.284 以降が必要です

<h3 id="effort-isnt-available-with-thinking-turned-off">
  Effort isn't available with thinking turned off
</h3>

[拡張思考](/docs/ja/model-config#extended-thinking)をオフにして、[effort レベル](/docs/ja/model-config#adjust-effort-level)を `high` より上にして実行しました。モデルはその組み合わせを受け入れないため、API はリクエストを拒否しました。

```text theme={null}
API Error: Effort 'xhigh' isn't available with thinking turned off on this model · run /effort high to continue, or turn thinking back on (unset MAX_THINKING_TOKENS=0)
```

`·` の後のヒントはセッションによって異なります：非対話セッションでは `use --effort high (or the effortLevel setting)` と表示され、Claude Desktop アプリが実行するセッションでは `you can lower effort to High` と表示されます。

**対応方法：**

* [effort レベルを](/docs/ja/model-config#set-the-effort-level) `high` 以下に下げてください。
* 思考をオンに戻してください。たとえば、[`MAX_THINKING_TOKENS`](/docs/ja/env-vars) を未設定にするか、設定から [`"alwaysThinkingEnabled": false`](/docs/ja/settings-reference#alwaysthinkingenabled) を削除してください。

v2.1.242 より前では、Claude Code は API 独自のメッセージを表示していました：`API Error: 400 output_config.effort 'xhigh' is not supported when thinking is disabled on this model. Use effort 'high' or below, or enable thinking.`v2.1.251 より前では、Claude Code は設定された effort レベルでリクエストを送信していたため、思考がオフの場合、Opus 5 は `high` を超えるすべてのリクエストを拒否していました。現在、Claude Code は Opus 5 など、この組み合わせを拒否することがわかっているモデルには代わりに effort `high` を送信します。

<h3 id="thinking-budget-exceeds-output-limit">
  思考予算が出力制限を超えています
</h3>

設定された拡張思考の予算が最大応答長を超えているため、実際の回答のためのスペースが残っていません。

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

**対応方法：**

* [`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/docs/ja/env-vars) を思考予算より大きくしてください
* 予算が出力長とどのように相互作用するかについては、[拡張思考](/docs/ja/model-config#extended-thinking)を参照してください

<h3 id="tool-use-or-thinking-block-mismatch">
  ツール使用または思考ブロックの不一致
</h3>

会話履歴が矛盾した状態で API に到達しました。

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 orphaned tool_result in conversation history. Run /rewind to recover the conversation.
API Error: 400 duplicate tool_use ID in conversation history. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

すべてのバリアントは同じことを意味します：履歴内の `tool_use`、`tool_result`、`thinking` ブロックのシーケンスが、API が期待するものと一致しなくなっています。

**対応方法：**

* Opus 4.7 または Opus 4.8 を使用している場合は、最初に `claude update` を実行してください。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーすることがあり、`/rewind` ではそれを解消できません。
* `/rewind` を実行するか、Esc キーを 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。チェックポイントがどのように作成および復元されるかについては、[チェックポイント機能](/docs/ja/checkpointing)を参照してください。

<h3 id="invalid-data-in-redacted-thinking-block">
  Invalid data in redacted\_thinking block
</h3>

会話履歴内の以前のターンに含まれる `redacted_thinking` ブロックを受け入れられなかったため、API は 400 でリクエストを拒否しました。

```text theme={null}
API Error: 400 ... Invalid `data` in `redacted_thinking` block
```

Claude Code は会話の以前の思考をリクエストから除外し、1 回再試行するため、セッションはエラーを表示せずに続行されます。v2.1.282 より前では、Claude Code は拒否されたブロックを保持し、それ以降のすべてのターンが同じエラーで失敗しました。

**対応方法：**

* v2.1.281 以前を使用していて、すべてのターンがこのエラーで失敗する場合は、`claude update` を実行してセッションを再開してください
* エラーが続く場合は、`/clear` を実行してブロックを含まない会話を開始してください

<h3 id="unsupported-tool-content-removed">
  Unsupported tool content removed
</h3>

Claude Code が Anthropic API に直接接続し、保存されたセッションを読み込むまたはプレビューする場合、Anthropic API が受け入れないツールコンテンツを削除し、削除されたコンテンツが 2 つの思考ブロックの間にあった場所にこの行を残します：

```text theme={null}
[Unsupported tool content removed]
```

このようなコンテンツは、Anthropic API 以外のものが API の形式で応答した場合にセッションファイルに入り込みます。典型的には、[`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) で設定された、別のプロバイダーのツール呼び出しを変換するサードパーティプロキシです。Claude Code はセッションが Anthropic API に直接接続する場合にのみこれを削除し、セッションがプロキシ経由または別のプロバイダーで実行される場合は、保存された履歴をそのまま読み込みます。v2.1.246 より前では、Claude Code はツール使用とその結果を API に送り返し、再開されたセッションのすべてのターンが `messages.1.content.0.server_tool_use.name: Input should be 'web_search', 'web_fetch', ...` などの 400 エラーで失敗しました。

**対応方法：**

* プレースホルダー行が表示される場合は、対応は不要です。セッションは削除されたコンテンツなしで続行されます。
* 代わりに再開されたセッションのすべてのターンが 400 エラーで失敗する場合は、`claude update` を実行してセッションを再度再開してください。v2.1.246 より前のバージョンはコンテンツを削除しません。

<h3 id="role-system-must-precede-an-assistant-message">
  role 'system' must precede an 'assistant' message
</h3>

システムメッセージが、API が受け入れない会話内の位置にあるため、API は 400 でリクエストを拒否しました：

```text theme={null}
API Error: 400 messages.6: role 'system' must precede an 'assistant' message or end the array; ...
```

Claude Code は、リマインダーや添付ファイルのテキストの一部を会話内のシステムメッセージとして送信します。API がその位置を拒否した場合、Claude Code はそのテキストを代わりに通常のユーザーメッセージとして送信して、リクエストを 1 回再試行します。API の同種の配置に関する表現（`use the top-level 'system' parameter for the initial system prompt` など）にも同じ復旧が適用されます。

それでもエラーが表示される場合、拒否されたシステムメッセージは Claude Code が削除できるものではありません。これは通常、Claude Code と API の間のプロキシまたは [LLM ゲートウェイ](/docs/ja/llm-gateway)が独自のシステムメッセージを追加したことを意味します。

**対応方法：**

* [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) で設定されたプロキシまたはゲートウェイの背後でエラーがすべてのターンで繰り返される場合は、プロキシなしで接続して原因を確認し、その運用者にエラーを報告してください
* `/clear` を実行して新しい会話を開始してください。そこでもエラーが再発する場合、原因は保存された会話ではなく、リクエストの経路にあります。

v2.1.280 より前では、Claude Code はこの表現を認識しなかったため、拒否されたシステムメッセージが Claude Code 自体が送信したものである場合にもエラーが表示され、会話のそれ以降のすべてのターンが同じように失敗しました。

<h3 id="invalid-encrypted-content-in-search-result-block">
  Invalid encrypted\_content in search\_result block
</h3>

会話履歴に API が復号化できないホスト型 Web 検索コンテンツが含まれているため、API は 400 でリクエストを拒否しました。表現は読み取れないフィールドを示します：

```text theme={null}
API Error: 400 ... Invalid `encrypted_content` in `search_result` block
API Error: 400 ... Invalid `encrypted_index` in `text` block
API Error: 400 ... Failed to decrypt web search result content
API Error: 400 ... Invalid `encrypted_stdout` in `encrypted_code_execution_result` block
```

API のホスト型 [Web 検索ツール](https://platform.claude.com/docs/en/agents-and-tools/tool-use/web-search-tool)からの結果には、API のみが読み取れる暗号化されたフィールドが含まれています。`encrypted_stdout` の表現は、そのような結果を読み取ったホスト型コード実行プログラムの出力を示しており、API はこれも暗号化します。API は、別の組織向けに生成されたコンテンツなど、復号化できないコンテンツを再送するリクエストを拒否します。

Claude Code 独自の [WebSearch ツール](/docs/ja/tools-reference#websearch-tool-behavior)は検索結果をプレーンテキストとして記録するため、これらのブロックは通常、ホスト型 Web 検索を自ら実行したプロキシまたは [LLM ゲートウェイ](/docs/ja/llm-gateway)を通じて会話に入り込みます。

3 つの Web 検索の表現については、Claude Code は検索呼び出し、結果、引用を送信内容から除外し、リクエストを 1 回再試行するため、セッションはエラーを表示せずに続行されます。`encrypted_stdout` の表現にはそのような復旧がないため、そのメッセージは引き続き表示されます。v2.1.282 より前では、Claude Code は拒否された Web 検索ブロックも保持し、それ以降のすべてのターンと `/compact` が同じように失敗しました。

**対応方法：**

* v2.1.281 以前を使用していて、すべてのターンが Web 検索の表現のいずれかで失敗する場合は、`claude update` を実行してセッションを再開してください
* エラーが続く場合、またはメッセージが `encrypted_stdout` を示す場合は、`/rewind` を実行してそのコンテンツを追加したターンの前のチェックポイントに戻るか、`/clear` を実行してそれを含まない会話を開始してください
* Claude Code をプロキシまたはゲートウェイの背後で実行している場合は、その運用者にエラーを報告してください

<h3 id="usage-policy-refusal">
  使用ポリシーによる拒否
</h3>

会話内のコンテンツが [使用ポリシー](https://www.anthropic.com/legal/aup)のチェックをトリガーしたため、API は応答を拒否しました。

メッセージに `` Details: `[reasoning_extraction]` `` という行が含まれている場合は、[セーフガードが Claude の推論を求めるリクエストを警告しました](#safeguards-flagged-a-request-for-claudes-reasoning)を参照してください。

メッセージには、拒否が誤りだと思われる場合にサポートに伝えることができるリクエスト ID とメッセージ ID が含まれています。

```text theme={null}
API Error: Opus 4.6 can't help with this. Start a new session to continue.

Send feedback with /feedback or learn more: https://www.anthropic.com/legal/aup
```

メッセージは拒否したモデルを示すか、モデルが記録されていない場合は `Claude` を示します。

チェックは最新のプロンプトだけでなく会話全体を評価するため、同じセッションで新しいメッセージを送信すると、通常、同じ拒否が再度トリガーされます。`--continue` または `--resume` でセッションを終了して再度開いた後も同様です。ディスク上のトランスクリプトにはまだトリガーとなったコンテンツが含まれているためです。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) では、このメッセージはモデルの安全対策がサイバーセキュリティのトピックとして警告したリクエストも対象とします。[安全対策がサイバーセキュリティのトピックを警告しました](#safety-measures-flagged-a-cybersecurity-topic)を参照してください。

v2.1.219 より前では、メッセージは `Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.` と表示されていました。

**対応方法：**

* Esc キーを 2 回押すか、`/rewind` を実行して、拒否をトリガーしたターンの前のチェックポイントに戻り、言い換えるか別のアプローチを試してください。[チェックポイント機能](/docs/ja/checkpointing)を参照してください。
* どのターンが原因であるかを特定できない場合は、`/clear` を実行して同じプロジェクトで新しい会話を開始してください。以前の会話はディスクに保持され、`/resume` で引き続き利用できます。
* 巻き戻しが利用できない [非対話モード](/docs/ja/headless)（`-p`）では、`--continue` なしの新しいセッションで、言い換えたプロンプトで再試行してください。ポリシーチェックはモデルによって異なるため、`--model` で別のモデルに切り替えることで拒否が解消される場合もあります。

<h3 id="safety-measures-flagged-a-cybersecurity-topic">
  安全対策がサイバーセキュリティのトピックを警告しました
</h3>

モデルの安全対策が、会話内のコンテンツをサイバーセキュリティのトピックとして警告しました。メッセージはリクエストを警告したモデルを示します：

```text theme={null}
API Error: Opus 4.8's safeguards flagged this message. Our intentionally broad safeguards allow us to deliver more capabilities faster, but can sometimes flag legitimate cybersecurity work. Apply to the Cyber Verification Program to reduce these interruptions. Send feedback with /feedback or learn more: https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude
```

メッセージに `` Details: `[reasoning_extraction]` `` という行が含まれている場合は、[セーフガードが Claude の推論を求めるリクエストを警告しました](#safeguards-flagged-a-request-for-claudes-reasoning)を参照してください。

メッセージは、正当なサイバーセキュリティ作業へのアクセスを付与する [Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude) にリンクしています。Opus 5.5 と Sonnet 5.5 では、メッセージは代わりに `<model>'s safeguards flagged this session` で始まります。警告されたカテゴリにフォールバックモデルが利用可能な場合、Claude Code はこのエラーを表示するのではなく [モデルを切り替えます](/docs/ja/model-config#automatic-model-fallback)。

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、[Microsoft Foundry](/docs/ja/microsoft-foundry) では、サイバーセキュリティの警告は代わりに [使用ポリシーによる拒否](#usage-policy-refusal)のメッセージになります。

セーフガード自体はサーバー側にあり、v2.1.203 より前から存在しています。それ以降のクライアントリリースで変更されたのはメッセージの表現のみです。
v2.1.203 から v2.1.218 までは、メッセージは `<model> has safety measures that flagged this message for a cybersecurity topic. To learn about the Cyber Verification Program and apply for access, visit our help center:` と表示され、その後に同じヘルプセンターのリンクが続き、対話セッションでは `If you were not engaging in a cybersecurity topic, please send feedback via /feedback.` が追加されていました。
v2.1.203 より前では、`<model>'s safeguards flagged this message for a cybersecurity topic. If your work requires this access, you can apply for an exemption:` と表示され、その後に免除申請フォームのリンクが続いていました。

**対応方法：**

* 作業にこのコンテンツが必要な場合は、[Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude) を通じてアクセスを申請してください
* リクエストがサイバーセキュリティのトピックに関するものではなかった場合は、`/feedback` を実行して誤検知を報告してください
* 同じセッションで作業を続けるには、Esc キーを 2 回押すか、`/rewind` を実行して、警告をトリガーしたターンの前のチェックポイントに戻り、別のアプローチを試してください。[チェックポイント機能](/docs/ja/checkpointing)を参照してください。

<h3 id="safeguards-flagged-a-request-for-claudes-reasoning">
  セーフガードが Claude の推論を求めるリクエストを警告しました
</h3>

モデルに内部の推論を応答内で再現するよう求めるものとしてセーフガードがリクエストを警告したため、API はリクエストを拒否しました。API はこの [拒否カテゴリ](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback#refusal-response)を `reasoning_extraction` と呼び、拒否メッセージには次の行が含まれます：

```text theme={null}
Details: `[reasoning_extraction]`
```

v2.1.234 より前では、拒否メッセージに `Details` 行は含まれていませんでした。

**対応方法：**

* Claude に思考や推論をそのまま、または固定形式で書き出すよう求める指示（`<thinking>` セクション、スクラッチパッドセクション、JSON 出力の `reasoning` フィールドなど）を削除するか、言い換えてください。この指示は、プロンプト内にある場合もあれば、Claude Code がプロンプトとともに読み込むカスタマイズ（CLAUDE.md、スキル、サブエージェントのプロンプト、出力スタイル、MCP ツールの説明など）内にある場合もあります。
* カスタマイズがトリガーかどうかを確認するには、ターミナルで [`claude --safe-mode`](/docs/ja/cli-reference#cli-flags) を実行してカスタマイズを無効にしたセッションを開始し、同じプロンプトを送信してください
* カスタマイズを変更した後は、新しいセッションを開始してください
* すでに送信したプロンプトを言い換えるには、[巻き戻しと要約](/docs/ja/checkpointing#rewind-and-summarize)を参照してください
* Claude に回答の説明を求めることは引き続き可能です。短い説明、結果の根拠、または実行したアクションの要約を求めてください。Claude の思考の要約を読むには、[`showThinkingSummaries`](/docs/ja/settings-reference#showthinkingsummaries) を参照してください。
* その他の例や、言い換えたリクエストが引き続き拒否される場合の対応については、[Keep reasoning in thinking blocks](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback#keep-reasoning-in-thinking-blocks)を参照してください

<h3 id="output-blocked-by-content-filtering-policy">
  Output blocked by content filtering policy
</h3>

API の出力コンテンツフィルターが、Claude が生成していた応答を停止しました。メッセージテキストは API から送られます：

```text theme={null}
API Error: Output blocked by content filtering policy
```

**対応方法：**

* 最後のメッセージを言い換えるか、別のアプローチを試してください
* ブロックをトリガーしたターンの前のチェックポイントに戻るには、Esc キーを 2 回押すか、`/rewind` を実行してください。[チェックポイント機能](/docs/ja/checkpointing)を参照してください

<h2 id="installation-errors">
  インストールエラー
</h2>

これらのエラーは、[インストールスクリプト](/docs/ja/setup#install-claude-code)、`claude install`、または `claude update` から Claude Code をインストールまたは更新する際に表示されます。セットアップ中の `command not found`、PATH、権限、および TLS の問題については、[インストールとログインのトラブルシューティング](/docs/ja/troubleshoot-install)を参照してください。

<h3 id="installation-was-killed-before-it-could-finish">
  インストールが完了する前に終了されました
</h3>

インストールスクリプトは、`claude install` ステップがシグナルによって終了されたときに報告します。Linux では、終了コード 137 はプロセスが SIGKILL を受け取ったことを意味し、メモリが少ないホストでは通常、カーネルのメモリ不足（OOM）キラーです。スクリプトはこの説明を出力し、コード 137 で終了します。

```text theme={null}
Installation was killed before it could finish (exit code 137). This usually means the system ran out of memory.
Claude Code needs roughly 512MB of free memory to install. Free up memory, then run this script again.
```

その他の致命的なシグナルの場合、および macOS でのコード 137 の場合、スクリプトは `Installation was killed before it could finish (exit code <N>)` を出力し、実際の終了コードを表示し、メモリ不足の説明は省略します。メッセージは macOS と Linux が使用するインストールスクリプトから来ており、WSL 内のインストールもカバーしています。ネイティブ Windows インストールスクリプトはこれを出力しません。v2.1.200 より前では、スクリプトはシェルの単なる `Killed` 行でのみ終了していました。

**対処方法：**

* 他のプロセスを停止してメモリを解放し、インストーラーを再実行します
* スワップスペースを追加するか、より大きなインスタンスに移動します。[低メモリ Linux サーバーでのインストール終了](/docs/ja/troubleshoot-install#install-killed-on-low-memory-linux-servers)を参照して、スワップファイルコマンドを確認してください。

<h3 id="the-connection-dropped-while-downloading-the-update">
  更新のダウンロード中に接続が切断されました
</h3>

ダウンロードサーバーへの接続が `claude install` または `claude update` が Claude Code バイナリをフェッチしている間に閉じられ、リトライが回復しませんでした。Claude Code は、接続がドロップされた場合、転送が停止した場合、またはダウンロードされたファイルがチェックサムに失敗した場合、最大 3 回の試行でダウンロードを再試行します。404 などの完了した HTTP エラーは、サーバーが既に応答しているため再試行されません。v2.1.202 より前では、単一の接続ドロップはダウンロードを即座に失敗させ、リトライの代わりに単なるエラー `aborted` を表示していました。

```text theme={null}
The connection dropped while downloading the update (attempt 3/3: aborted). Check your network — proxies sometimes cut off large downloads.
```

括弧内のテキストは、失敗した試行と基になるネットワークエラーを示します。`claude update` は stderr でメッセージの前に `Error: Failed to install native update` を付けます。

接続は保持されているがダウンロードが 10 分以内に完了しない場合、代わりに `Download timed out: exceeded the total deadline` で失敗します。Claude Code はタイムアウトしたダウンロードを再試行しません。期限内に完了するのに十分な速度がない接続は、即座に再試行しても完了しないためです。以下の手順は両方のメッセージに適用されます。

プロキシまたはゲートウェイは、完了する前に長い転送を閉じることができ、Claude Code バイナリは大きなダウンロードです。

**対処方法：**

* `claude update` を再度実行します。それ以外の場合は健全なネットワークで、ダウンロードは通常、次の実行で成功します。タイムアウトメッセージの場合は、より高速またはスロットルされていないネットワークから再度実行します。
* ネットワークがプロキシを必要とする場合は、インストーラーまたは `claude update` を実行する前に `HTTPS_PROXY` を設定します。[ネットワーク接続の確認](/docs/ja/troubleshoot-install#check-network-connectivity)を参照してください。
* 企業プロキシが転送を閉じ続ける場合は、ネットワークチームに `downloads.claude.ai` からの完全なダウンロードを許可するよう依頼します。[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements)を参照してください。
* シェルから `claude doctor` を実行して、インストール診断を実行します

<h2 id="command-line-errors">
  コマンドラインのエラー
</h2>

これらのエラーは、`claude` コマンドラインとそのサブコマンド、プロンプトで送信したコマンド名、および `/security-review` のようにプロンプトの実行前にシェルコマンドを実行してコンテキストを収集するコマンドから発生します。CLI を再起動する `/tui` からも発生します。

<h3 id="conflict-between-bg-and-print">
  `--bg` と `--print` の競合
</h3>

このメッセージには Claude Code v2.1.198 以降が必要です。同じ `claude` の呼び出しで `--bg` と `-p` または `--print` を組み合わせています。`--bg` は後で `claude agents` でアタッチする[バックグラウンドセッション](/docs/ja/agent-view#from-your-shell)を開始しますが、`--print` は[非対話](/docs/ja/headless)で実行され、`claude agents` がアタッチする対話セッションを開始しません。v2.1.198 より前は、この組み合わせによって、アタッチできないバックグラウンドジョブが何も通知されずに作成されていました。

```text theme={null}
--bg and --print conflict: --print never starts the interactive session that `claude agents` attaches to, so the job would be unattachable. The prompt is the positional — drop --print: `claude --bg '<task>'`.
```

**対処方法:**

* `-p` または `--print` を削除します。`--bg` はプロンプトを位置引数として受け取るため、`claude --bg "<task>"` だけで完全なコマンドになります。[シェルから新しいエージェントをディスパッチする](/docs/ja/agent-view#from-your-shell)を参照してください。
* バックグラウンドセッションを作成せずにプロンプトを非対話で実行して結果を出力するには、`--bg` を削除して `claude -p "<task>"` を実行します

<h3 id="conflict-between-a-system-prompt-flag-and-its-file-form">
  システムプロンプトのフラグとそのファイル形式の競合
</h3>

1 回の `claude` の呼び出しで [`--append-subagent-system-prompt`](/docs/ja/cli-reference#cli-flags) と `--append-subagent-system-prompt-file` を同時に渡したため、`claude` はセッションを開始せずに終了コード 1 で終了します:

```text theme={null}
Error: Cannot use both --append-subagent-system-prompt and --append-subagent-system-prompt-file. Please use only one.
```

v2.1.283 より前は、`--system-prompt` と `--system-prompt-file`、または `--append-system-prompt` と `--append-system-prompt-file` を同時に渡した場合も、`claude` は同じように終了していました。これらの組み合わせは[結合](/docs/ja/cli-reference#system-prompt-flags)されずに競合していたためです。これらのバージョンでは、メッセージに組み合わせたフラグの組が表示されます。

**対処方法:**

* フラグの一方の形式だけを残し、もう一方を削除します。固定のプロンプトファイルと実行ごとのテキストを組み合わせたい場合は、両方のフラグを渡すのではなく、起動前にテキストをファイルにマージします

<h3 id="invalid-agents-configuration">
  無効な `--agents` 設定
</h3>

`--agents` に渡した値が無効なため、`claude` はセッションを開始せずに終了コード 1 で終了します。`--safe-mode` を渡すか [`CLAUDE_CODE_SAFE_MODE`](/docs/ja/env-vars#variables) を設定している場合、Claude Code は `--agents` を完全に無視します。`--resume` または `--continue` を使用している場合、インラインの JSON 値はチェックされずにセッションが開始されます。ファイルから読み込んだ値は起動のたびにチェックされます。v2.1.242 より前は、Claude Code はそのままセッションを開始していました。

```text theme={null}
Error: Invalid --agents configuration:
<what failed>
```

1 行目以降に表示される内容は、値がどのように失敗したかによって異なります。Claude Code は次のチェックを順に実行し、最初に失敗したチェックで停止します。値に 2 種類の問題がある場合、2 つ目の問題は 1 つ目を修正した後にのみ表示されます:

1. 値が `{` で始まるものの JSON として解析できない場合、または `--agents` ファイルの内容を解析できない場合、Claude Code は JSON パーサー自身のメッセージを含む `invalid JSON:` 行を 1 行出力します
2. 解析はできたものの、エージェント定義が [CLI で定義されたサブエージェント](/docs/ja/sub-agents#choose-the-subagent-scope)のスキーマに一致しない場合、Claude Code は問題ごとに 1 行を出力します
3. エージェント名が `-` で始まる場合、Claude Code は `<name>: agent names must not start with '-'` を出力します

問題の行が 20 行を超える場合、Claude Code は最初の 20 行を出力し、残りを `…and N more` に置き換えます。

`--print` を使用する場合、`--agents` はインラインオブジェクトの代わりに [JSON ファイルへのパス](/docs/ja/sub-agents#choose-the-subagent-scope)も受け付けます。v2.1.281 より前は、`--agents` はインライン JSON のみを受け付け、ファイルパスを無効な JSON として扱っていました。ファイル形式には独自の拒否があり、このメッセージの代わりに出力されます。次のようなものがあります:

* **`Error: --agents takes a JSON object, or a file path only with --print (-p)`**: Claude Code が対話セッションで値をファイルパスとして読み取りました。定義をインライン JSON として渡すか、`-p` を追加してファイルから読み込みます。
* **`Error: --agents file not found: <path>`**: そのパスにファイルが存在しません。`{` で始まらず有効な JSON でもない値はパスとして読み取られるため、シェルによって崩れたインライン JSON もこの形で失敗することがあります。パスまたはクォートを確認して、コマンドを再度実行してください。

**対処方法:**

* メッセージに列挙された各問題を修正してから、コマンドを再度実行します。[CLI で定義されたサブエージェントが受け付けるフィールド](/docs/ja/sub-agents#choose-the-subagent-scope)を参照してください。

<h3 id="cloud-sessions-cannot-be-created-from-a-restricted-session">
  `--restricted` セッションからクラウドセッションを作成できない
</h3>

[`--restricted`](/docs/ja/cli-reference#cli-flags) でセッションを開始した場合、Claude Code はそのセッションから[クラウドセッション](/docs/ja/claude-code-on-the-web#from-terminal-to-cloud)を作成することを拒否します。新しいセッションは制限されたプロセスの外で実行され、制限モードが適用されないためです。Claude Code はサーバーに接続する前にクライアント側で拒否するため、クラウドセッションは作成されません:

```text theme={null}
Cloud sessions cannot be created from a --restricted session: they would not enforce it.
```

**対処方法:**

* 制限されたセッション内でタスクをローカルに実行します
* セッションの起動方法を制御できる場合は、`--restricted` を付けずに新しい `claude` セッションを開始し、そこからクラウドセッションを作成します

v2.1.248 より前の Claude Code には `--restricted` フラグがなく、それ以前のバージョンではフラグ自体が不明なオプションのエラーとして拒否されます。

<h3 id="cloud-sessions-are-disabled-by-your-organizations-policy">
  組織のポリシーによりクラウドセッションが無効になっている
</h3>

組織の `allow_remote_sessions` ポリシーがオフになっているため、[クラウドセッション](/docs/ja/claude-code-on-the-web)とそれを使用するコマンドは利用できません:

```text theme={null}
Cloud sessions are disabled by your organization's policy. Contact your organization admin to enable them.
```

このメッセージは、[ターミナルからクラウドセッションを作成する](/docs/ja/claude-code-on-the-web#from-terminal-to-cloud)とき、および `/teleport`、`/remote-env`、`/web-setup` など、クラウドセッションを必要とするコマンドを送信したときに表示されます。v2.1.268 より前は、これらのコマンドを送信すると代わりに [`Unknown command`](#unknown-command) が返されていました。

これはサーバー側の組織ポリシーであるため、ローカル設定、環境変数、CLI フラグで上書きすることはできません。

Claude Code が組織のポリシーをまだ読み込んでいないか、取得できない場合、これらのコマンドは代わりに `Couldn't verify your organization's policy for cloud sessions. Check your network connection, then restart Claude Code and try again.` と応答します。

**対処方法:**

* 組織の [Owner](/docs/ja/server-managed-settings#access-control) に、[claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) の Claude Code 管理設定でクラウドセッションを有効にするよう依頼します
* ポリシーを確認できなかったというメッセージの場合は、ネットワーク接続を確認してから Claude Code を再起動し、再度お試しください

<h3 id="the-json-schema-value-is-not-a-valid-json-schema">
  `--json-schema` の値が有効な JSON Schema ではない
</h3>

[非対話モード](/docs/ja/headless#get-structured-output)で [`--json-schema`](/docs/ja/cli-reference#cli-flags) に渡したスキーマが JSON Schema のコンパイルに失敗したため、`claude` はプロンプトを実行せずに終了コード 1 で終了します。v2.1.205 より前は、無効なスキーマはエラーなしで構造化されていない出力を生成し、`format` キーワードを使用するスキーマはすべて無効として扱われていました。

```text theme={null}
Error: --json-schema is not a valid JSON Schema: data/type must be equal to one of the allowed values
```

2 つ目のコロンの後のテキストはバリデーターの診断メッセージで、失敗したキーワードまたは場所を示します。`"format": "email"` のように `format` キーワードを使用するスキーマは有効です。Claude Code は `format` をアノテーションとして受け付けますが、強制はしません。

Claude Code はスキーマのコンパイル前に 2 つのチェックを実行します。JSON として解析できない値は `Error: --json-schema is not valid JSON` で拒否し、オブジェクトではない有効な JSON は `Error: --json-schema must be a JSON object` で拒否します。

**対処方法:**

* 診断メッセージが示すスキーマの部分を修正してから、コマンドを再実行します
* 動作するスキーマとコマンドについては、[構造化された出力を取得する](/docs/ja/headless#get-structured-output)を参照してください

<h3 id="settings-file-exceeds-the-2mib-limit">
  設定ファイルが 2MiB の上限を超えている
</h3>

[`--settings`](/docs/ja/cli-reference#cli-flags) に渡したファイルが 2 MiB を超えているため、`claude` はファイルを読み込まずに起動時に終了コード 1 で終了します。v2.1.214 より前は、Claude Code はサイズをチェックせずにファイルを読み込んでいたため、数ギガバイトのファイルや `/dev/zero` のようなデバイスファイルによってメモリが際限なく増加していました。

```text theme={null}
Error: Settings file exceeds the 2MiB limit: /path/to/settings.json
```

Claude Code は、通常のファイルではない `--settings` のパスも同様に拒否します。デバイス、FIFO、ソケットの場合は `Error: Cannot use settings file (Not a regular file (device, FIFO, or socket))` の後にパスが表示され、ディレクトリの場合は `EISDIR` が理由として表示されます。

**対処方法:**

* `--settings` に 2 MiB 未満の通常の JSON 設定ファイルを指定します。形式については[設定](/docs/ja/settings)を参照してください。

<h3 id="the-current-directory-no-longer-exists">
  現在のディレクトリが存在しない
</h3>

シェルがディレクトリに入った後に削除または移動されたディレクトリから `claude` を起動しました。たとえば、別のシェルが削除した worktree や一時ディレクトリなどです。Claude Code は作業ディレクトリを読み取れないため、対話モードと[非対話](/docs/ja/headless)モードのどちらでも、セッションを開始する前に終了コード 1 で終了します。v2.1.239 より前は、Claude Code はこのメッセージの代わりに、stderr に圧縮されたバンドルのソースと生の `ENOENT ... uv_cwd` スタックを出力してクラッシュしていました。

```text theme={null}
The current directory no longer exists (it was deleted or moved). Start Claude Code from an existing directory.
error: The current working directory was deleted, so that command didn't work. Please cd into a different directory and try again.
```

どちらの形式でも原因と対処方法は同じです。

権限の変更など別の理由で Claude Code が作業ディレクトリを読み取れない場合、メッセージには代わりにエラーコードが表示されます: `Can't read the current directory (EACCES). Start Claude Code from a different directory.`

macOS で `~/Desktop`、`~/Documents`、`~/Downloads`、または iCloud Drive 内のディレクトリに対して `EPERM` が表示される場合、通常は macOS がターミナルアプリからそのフォルダーへのアクセスをブロックしていることを意味します。そのフォルダーを読み取る他のコマンドも同様に失敗します。そこで `ls` を実行すると、`sudo` を付けても `Operation not permitted` が表示されます。

**対処方法:**

* ホームディレクトリやプロジェクトディレクトリなど、存在するディレクトリに移動してから、再度 `claude` を実行します
* ディレクトリが同じパスに再作成された場合、シェルはまだ削除されたディレクトリを保持しています。`cd "$PWD"` を実行するか、ディレクトリから出て入り直してから、再度 `claude` を実行します
* macOS で `EPERM` が表示される場合は、Cmd+Q でターミナルアプリを終了し、再度開いてそのフォルダーに戻り、`claude` を実行します。そのフォルダーでの `ls` が引き続き失敗する場合は、**システム設定 > プライバシーとセキュリティ > ファイルとフォルダ** を開き、ターミナルアプリに対してそのフォルダーをオンにしてから、ターミナルを開き直します

<h3 id="temp-directory-refused-or-cannot-be-created">
  一時ディレクトリが拒否される、または作成できない
</h3>

macOS と Linux では、Claude Code は起動時に、システムの一時ディレクトリまたは [`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) による上書き先の下に、プライベートな一時ディレクトリ `claude-<uid>` を作成します。ディレクトリを作成できない場合、またはそのパスにすでに存在するエントリが安全性チェックに失敗した場合、Claude Code はセッションを開始せずに、失敗内容を stderr に出力して終了コード 1 で終了します:

```text wrap theme={null}
ENOSPC: no space left on device, mkdir '/tmp/claude-501'

Temp directory /tmp/claude-501 is not a directory (may be an attacker-planted symlink). Refusing to use it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.

Temp directory /tmp/claude-501 is owned by uid 502, expected 501. Refusing to use it — another user may have pre-created it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.

Temp directory /tmp/claude-501 is not readable (its mode may have been altered, or a path component denies search). Refusing to use it — restore its permissions (chmod 0700) or remove it. Set CLAUDE_CODE_TMPDIR to a directory you control, or ask an administrator to remove it.
```

**対処方法:**

* `ENOSPC` の場合は、一時ディレクトリがあるボリュームのディスク容量を空けます
* `Refusing to use it` 形式の場合は、リンク先ではなく指定されたエントリ自体を削除して、Claude Code を再度起動します。`owned by uid` 形式の場合、削除できるのは管理者またはそのユーザーのみです
* `is not readable` の場合は、指定されたディレクトリに対して `chmod 0700` を実行するか、ディレクトリを削除して再度起動します
* いずれの場合も、拒否されたパスには手を付けずに、[`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) を自分が管理するディレクトリに設定して Claude Code を再度起動できます

<h3 id="directory-couldnt-be-resolved-to-a-real-location">
  ディレクトリを実際の場所に解決できない
</h3>

作業ディレクトリのサブディレクトリに対して `/add-dir` を実行しましたが、Claude Code がそのディレクトリを実際の場所に解決できませんでした。

作業ディレクトリのサブディレクトリにはすでにファイルアクセス権があるため、`/add-dir` はそのスキル、コマンド、エージェントを読み込むだけです。これらを読み込む前に、Claude Code はシンボリックリンクを解決したディレクトリの実際の場所が作業ディレクトリ内にあることを確認します。Claude Code がその場所を解決できない場合、何も読み込まずに次のメッセージを表示します:

```text theme={null}
packages/app couldn't be resolved to a real location, so its skills, commands, and agents weren't loaded. Check that it is a directory inside the working directory and try again.
```

**対処方法:**

* パスが作業ディレクトリ内の実際のディレクトリを指していることを確認してから、再度 `/add-dir` を実行します
* このメッセージはファイルアクセスを変更しません。ディレクトリの `.claude/` の内容が読み込まれなかったことを報告するだけです

v2.1.261 より前は、作業ディレクトリが `/net/<host>` のオートマウント上にある場合、すべての `/add-dir <subdirectory>` でもこのメッセージが表示されていました。そこでは Claude Code が設計上パスの解決を行わないため、ディレクトリには問題がなく、再試行しても解決しませんでした。

<h3 id="workspace-not-trusted-when-starting-remote-control">
  Remote Control の開始時にワークスペースが信頼されていない
</h3>

信頼していないディレクトリで、`claude remote-control` またはそのエイリアスの `claude rc` を使用して [Remote Control](/docs/ja/remote-control) サーバーモードを開始しましたが、コマンドがディレクトリを信頼するかどうかを尋ねることができませんでした。たとえば、コマンドの標準入力または標準出力のいずれかがリダイレクトまたはパイプされているため、ターミナルではない場合です。コマンドは終了コード 1 で終了します:

```text theme={null}
Error: Workspace not trusted. Please run `claude` in /Users/you/project first to review and accept the workspace trust dialog.
```

同じく `Error: Workspace not trusted.` で始まる 2 つのバリエーションは、ディレクトリを信頼することで有効になる内容を表示するにはターミナルが小さすぎる場合、またはターミナルがサイズを報告しなかった場合に表示されます。ウィンドウを拡大するか通常のターミナルウィンドウに切り替えてから、再度 `claude rc` を実行します。

ホームディレクトリではメッセージが異なります。ワークスペースの信頼ダイアログはホームディレクトリに対する信頼を保存しないため、そこで承諾してもこのチェックを満たすことができないからです。v2.1.214 より前は、ホームディレクトリでも上記のメッセージが表示されていましたが、そのアドバイスはホームディレクトリでは成功しませんでした。

```text theme={null}
Error: Workspace not trusted. /Users/you is your home directory, and for security home-directory trust is never saved, so running `claude` here first won't help. Run `claude rc` from a project directory instead (run `claude` there once to accept the trust dialog).
```

[`Trust <directory>?` の質問](/docs/ja/remote-control#requirements)で `n` と答えるか Enter を押すと、コマンドはディレクトリ名を含む `Remote Control did not start` メッセージを出力し、終了コード 1 で終了します。再度 `claude rc` を実行して `y` と答えてください。

**対処方法:**

* まずターミナルからディレクトリを信頼します。そこで `claude rc` を実行して `y` と答えるか、そこで `claude` を実行して[ワークスペースの信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust)を承諾してから、元のコマンドを再度実行します
* ホームディレクトリにいる場合は、プロジェクトディレクトリに移動してそこで Remote Control を開始します

v2.1.284 より前は、ターミナル内であってもコマンドが確認を求めることはありませんでした。

<h3 id="not-carried-over-to-the-sessions-remote-control-starts">
  Remote Control が開始するセッションに引き継がれない
</h3>

`remote-control` 動詞の前に、Remote Control が開始するセッションを制限または設定するグローバルな `claude` フラグ（`--settings`、`--setting-sources`、`--permission-mode`、`--disallowed-tools`、`--mcp-config` など）を付けて [Remote Control](/docs/ja/remote-control) を開始しました。動詞の前に置かれたフラグは、それらのセッションに届きません。Claude Code は代わりにフラグ名を示して開始を拒否します:

```text theme={null}
Error: `--settings` before `remote-control` is not carried over to the sessions Remote Control starts, so Remote Control refuses to start rather than drop it — remove it, and give Remote Control's own options after the verb (see `claude remote-control --help`).
```

`--verbose`、`--model`、ラッパーによって挿入される `--session-id` や `--plugin-dir` など、破棄しても無害なグローバルフラグについては、Claude Code は拒否しません。それらを無視して Remote Control を開始します。

Claude Code は、まだ無害と認識していないグローバルフラグに対しても開始を拒否します。そのため、新しいリリースで追加されたフラグは、後のリリースで無害とマークされるまでこのメッセージに表示される場合があります。

**対処方法:**

* 動詞の前からフラグを削除し、[Remote Control 独自のオプション](/docs/ja/remote-control#start-a-remote-control-session)を動詞の後に渡します。`claude remote-control --help` でオプションの一覧を確認できます
* 拒否されたフラグが `--permission-mode` の場合は、`claude remote-control --permission-mode <mode>` を実行して、Remote Control が開始するセッションの権限モードを設定します

v2.1.248 より前は、グローバルフラグが先に来ると `claude remote-control` は独自のフラグを受け付けず、コマンドは `unknown option` エラーで失敗していました。

<h3 id="claude-import-is-not-yet-available-in-this-build">
  claude import がこのビルドではまだ利用できない
</h3>

[`claude import`](/docs/ja/cli-reference#cli-commands) を実行しましたが、Claude Code がインポートフローがオフになっていることを検出したため、コマンドはインポートを開始せずに終了コード 1 で終了します。v2.1.222 より前は、インポートフローがオフになっているビルドでは、このメッセージを出力する代わりに `import` をプロンプトとして扱い、対話セッションを開始していました。

```text theme={null}
`claude import` is not yet available in this build. Run `claude` and use /mcp or edit ~/.claude/settings.json directly.
```

Claude Code は、Anthropic から取得してディスクにキャッシュする機能フラグを通じて `claude import` をオンにします。このメッセージは、キャッシュされた値がオフであることを意味します。原因は通常、次のいずれかです:

* インストール後にセッションを開始していないため、Claude Code がまだフラグを取得していません。機能が利用可能な場合でも、最初の `claude import` でこのメッセージが表示されることがあります。
* Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、Claude Platform on AWS、または [Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway#availability-and-limitations)を通じて Claude Code を使用しています。これらのセッションでは Claude Code は機能フラグを取得しないため、`claude import` は利用できないままです。
* 機能フラグの取得をオフにする `DISABLE_TELEMETRY`、`DO_NOT_TRACK`、`DISABLE_GROWTHBOOK`、または [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) を設定しているため、`claude import` は利用できないままです。

**対処方法:**

* 新規インストールの場合は、`claude` を起動してセッションが読み込まれるのを待ち、終了してから再度 `claude import` を実行します
* 機能フラグの取得がオフのままの場合は、設定を自分で行います。[`claude mcp add`](/docs/ja/mcp#installing-mcp-servers) で MCP サーバーを追加し、引き継ぎたい [`CLAUDE.md` ファイル](/docs/ja/memory#how-claude-md-files-load)、[スキルとコマンド](/docs/ja/skills#where-skills-live)、[サブエージェント](/docs/ja/sub-agents#choose-the-subagent-scope)を作成します。メッセージには `~/.claude/settings.json` も示されています。`claude import` が引き継ぐ設定のうち、このファイルに含まれるのは[権限モード](/docs/ja/settings-reference#permission-settings)のみで、Claude Code はこのファイルから MCP サーバーを読み込みません。

<h3 id="could-not-read-claude-code-config">
  Claude Code の設定を読み取れない
</h3>

Claude Code がログイン情報とプロジェクトごとの状態を保存するファイルである `~/.claude.json` を解析できない状態で、[`claude import`](/docs/ja/cli-reference#cli-commands) を実行しました。このサブコマンドは利用可否を確認するためにこのファイルを読み取りますが、対話セッションが表示する復旧ダイアログを表示しないため、終了コード 1 で終了します。v2.1.222 より前は、設定ファイルを読み取れない状態で `claude import` を実行すると対話セッションが開始され、その復旧ダイアログがファイルを処理していました。

```text theme={null}
Could not read Claude Code config — run `claude` with no arguments to recover it.
```

**対処方法:**

* 引数なしで `claude` を実行します。Claude Code は無効なファイルを検出し、リセットを提案します。その後、再度 `claude import` を実行します。
* 手動で加えた編集を保持したい場合は、代わりにエディターで `~/.claude.json` の JSON 構文を修正してから、`claude import` を再実行します

<h3 id="could-not-import-a-server-from-claude-desktop">
  Claude Desktop からサーバーをインポートできない
</h3>

`claude mcp add-from-claude-desktop` で選択したサーバーの 1 つを Claude Code が追加できませんでした。コマンドは選択された他のサーバーを引き続きインポートし、追加できなかったサーバーごとに 1 行を出力します。v2.1.205 より前は、最初に失敗したサーバーでインポートが停止していました。

```text theme={null}
Could not import my server: Invalid name my server. Names can only contain letters, numbers, hyphens, and underscores.
```

サーバー名の後のテキストが理由です。最も一般的な理由は名前のチェックです。Claude Desktop ではサーバー名にスペースやピリオドなどの文字を使用できますが、`claude mcp` では英字、数字、ハイフン、アンダースコアに制限されています。その他の理由には、検証に失敗したサーバー設定や、組織の [MCP ポリシー](/docs/ja/managed-mcp)によってブロックされたサーバーがあります。

**対処方法:**

* `claude_desktop_config.json` でサーバー名を英字、数字、ハイフン、アンダースコアのみを使用する名前に変更してから、再度 `claude mcp add-from-claude-desktop` を実行します
* 有効な名前で `claude mcp add` または `claude mcp add-json` を使用して、そのサーバーを直接追加します。[Claude Desktop から MCP サーバーをインポートする](/docs/ja/mcp#import-mcp-servers-from-claude-desktop)を参照してください。

<h3 id="cannot-add-mcp-server-to-the-managed-scope">
  MCP サーバーを managed スコープに追加できない
</h3>

`--scope managed` を指定して `claude mcp add` または `claude mcp add-json` を実行しました。このスコープには、組織が [`managedMcpServers`](/docs/ja/settings-reference#managedmcpservers) 管理設定を通じて提供するサーバーが含まれます。Claude Code はこれらを管理設定からのみ読み込むため、コマンドはこのスコープにサーバーを書き込めません。

```text theme={null}
Cannot add MCP server to scope: managed
```

**対処方法:**

* 書き込み可能なスコープ（`local`、`user`、または `project`）にサーバーを追加します。`--scope` を指定しない場合、コマンドは `local` を使用します。[MCP のインストールスコープ](/docs/ja/mcp#mcp-installation-scopes)を参照してください
* 組織内のすべてのユーザーにサーバーを提供するには、展開する管理設定の [`managedMcpServers`](/docs/ja/settings-reference#managedmcpservers) にサーバーを追加します

<h3 id="cannot-add-mcp-server-when-managed-settings-allow-only-plugin-servers">
  管理設定がプラグインのサーバーのみを許可している場合に MCP サーバーを追加できない
</h3>

組織の管理設定で [`strictPluginOnlyCustomization`](/docs/ja/settings-reference#strictpluginonlycustomization) が `true` または `mcp` を含むリストに設定されている状態で、`claude mcp add` または `claude mcp add-json` を実行しました。この設定では、Claude Code は `~/.claude.json` や `.mcp.json` から MCP サーバーを読み込まないため、コマンドは読み込まれることのないサーバーを保存せずに終了コード 1 で終了します:

```text theme={null}
Cannot add MCP server: your organization's managed settings allow only MCP servers that plugins provide. Install a plugin that provides this server, or ask your administrator to make it available.
```

`claude mcp add-from-claude-desktop` は、選択した各サーバーをインポートされなかったものとして報告し、このメッセージを理由として示します。[`/import`](/docs/ja/commands#all-commands) は追加しようとした MCP サーバーごとにこのメッセージを報告し、検出した他の項目は引き続きインポートします。

v2.1.284 より前は、これらのコマンドはサーバーを保存して成功を報告していましたが、サーバーは読み込まれませんでした。

**対処方法:**

* サーバーを提供する[プラグイン](/docs/ja/plugins/install)をインストールします
* 管理者に、サーバーを[プラグイン](/docs/ja/plugins/org)で配布するか、リモートの HTTP または SSE サーバーであれば [`managedMcpServers`](/docs/ja/settings-reference#managedmcpservers) を通じて提供するよう依頼します

<h3 id="cant-read-mcp-json">
  .mcp.json を読み取れない
</h3>

プロジェクトの [`.mcp.json`](/docs/ja/mcp#project-scope) を読み取るコマンド（`--scope project` を指定した `claude mcp add` や `claude mcp add-json`、または `claude mcp remove` など）が、現在のディレクトリにあるファイルが通常のファイルではないか 2 MiB を超えていることを検出したため、ファイルを読み取らずにこのエラーで終了します。

```text theme={null}
Can't read .mcp.json: it isn't a regular file or is larger than 2097152 bytes. Fix or remove it, then run the command again.
```

v2.1.257 より前は、`.mcp.json` が FIFO の場合はコマンドが出力なしで無期限に待機し、`/dev/zero` のようなデバイスファイルへのシンボリックリンクの場合はプロセスが強制終了されるまでメモリが増加していました。

**対処方法:**

* 現在のディレクトリの `.mcp.json` にあるものを確認します。[プロジェクトスコープの形式](/docs/ja/mcp#project-scope)の通常の JSON ファイルに置き換えるか削除してから、コマンドを再度実行します。

<h3 id="mcp-server-was-not-saved-or-removed">
  MCP サーバーが保存または削除されなかった
</h3>

`user` または `local` [スコープ](/docs/ja/mcp#mcp-installation-scopes)のサーバーに対して `claude mcp add`、`claude mcp add-json`、または `claude mcp remove` を実行しました。どちらのスコープも `~/.claude.json` に保存されますが、Claude Code が書き込み後にこのファイルを読み直したとき、変更が反映されていませんでした。コマンドは成功の行の代わりにこのエラーで終了します。

```text theme={null}
MCP server "example" was not saved to /home/user/.claude.json. If that file is read-only or protected by a sandbox, make it writable or run the command outside the sandbox, then add the server again.
```

削除の場合、メッセージは `was not removed from` となり、`then remove the server again` で終わります。`local` スコープのサーバーの場合、パスの後にそのエントリが属するプロジェクトディレクトリが `(local scope for /path/to/project)` の形式で表示されます。

v2.1.283 より前は、`claude mcp add`、`claude mcp add-json`、`claude mcp remove` は、変更がファイルに反映されなかった場合でも成功を報告していました。

**対処方法:**

* メッセージに示されたファイルを書き込み可能にするか、サンドボックスの外でコマンドを実行してから、同じ追加または削除コマンドを再度実行します。

<h3 id="mcp-server-may-not-have-been-saved-or-removed">
  MCP サーバーが保存または削除されていない可能性がある
</h3>

`user` または `local` [スコープ](/docs/ja/mcp#mcp-installation-scopes)のサーバーに対して `claude mcp add`、`claude mcp add-json`、または `claude mcp remove` を実行しましたが、Claude Code が変更を確認するために `~/.claude.json` を読み直すことができませんでした。変更はディスクに反映されている場合もされていない場合もあります。括弧内のテキストは、その読み取り時のエラーです。

```text theme={null}
MCP server "example" may not have been saved: /home/user/.claude.json could not be read to confirm the change (EACCES: permission denied, open '/home/user/.claude.json'). Run `claude mcp get example` to check, then add the server again if it is missing.
```

削除の場合、メッセージは `may not have been removed` となり、`then remove the server again if it is still listed` で終わります。

v2.1.283 より前は、変更を確認できなかった場合でもコマンドは成功を報告していました。

**対処方法:**

* `claude mcp get <name>` を実行して、変更がディスクに反映されているかを確認します。`local` スコープのサーバーの場合、ローカルスコープはプロジェクトごとであるため、サーバーが属するプロジェクトディレクトリから実行します。
* 追加後にサーバーが見つからない場合、または削除後もまだ一覧に表示される場合は、同じ追加または削除コマンドを再度実行します。

<h3 id="anthropic-hosted-and-doesnt-support-local-oauth">
  サーバーが Anthropic でホストされておりローカル OAuth をサポートしていない
</h3>

サードパーティの ID プロバイダーを通じて認証を行う、Anthropic がホストするコネクタのホストを URL が指している MCP サーバーに対して、サインインを開始しました。これらのホストには `microsoft365.mcp.claude.com`、`gmail.mcp.claude.com`、`gcal.mcp.claude.com` が含まれます。[これらのサインインは claude.ai を通じてのみ機能する](/docs/ja/mcp#use-mcp-servers-from-claude-ai)ため、Claude Code は `/mcp` パネルと `claude mcp login` のどちらからも、これらのホストに対するローカル OAuth フローの開始を拒否します。

```text theme={null}
"gmail" is Anthropic-hosted and doesn't support local OAuth. Connect it via Settings → Connectors on claude.ai (requires `claude login`), then it'll be available here automatically.
```

**対処方法:**

* `claude mcp remove <name>` で自分のエントリを削除し、同じ URL の claude.ai コネクタが隠れないようにします
* 削除した後、Claude Code で使用しているアカウントでサインインした状態で、[claude.ai/customize/connectors](https://claude.ai/customize/connectors) でサービスを接続します。接続すると、有効な認証方法が claude.ai のサブスクリプションログインである場合、[コネクタが Claude Code に自動的に表示されます](/docs/ja/mcp#use-mcp-servers-from-claude-ai)

<h3 id="server-rejected-the-authorization-header-minted-by-the-configured-headershelper">
  設定された headersHelper が生成した Authorization ヘッダーをサーバーが拒否した
</h3>

[`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) が `Authorization` ヘッダーを提供する MCP サーバーが、接続に対して HTTP 401 または 403 で応答したため、Claude Code は接続を失敗として報告します。ヘルパーが `Authorization` ヘッダーを提供するため、Claude Code はそのサーバーに対して [OAuth にフォールバックしません](/docs/ja/mcp#authenticate-with-remote-mcp-servers):

```text theme={null}
Server rejected the Authorization header minted by the configured headersHelper (HTTP 401). Check that the helper command returns a valid credential for this MCP endpoint — OAuth fallback is disabled when the helper supplies Authorization.
```

Claude Code は接続を試みるたびにヘルパーを再実行するため、トークンのローテーションの競合などの一時的な拒否の後に再試行すると、新しい認証情報で成功する場合があります。

**対処方法:**

* Claude Code が実行するのと同じ方法で、`headersHelper` コマンドを自分で実行します。[Claude Code が実行するディレクトリ](/docs/ja/mcp#where-the-helper-runs)から、[Claude Code が設定する環境変数](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication)を使用し、プロジェクトの `.mcp.json`、プラグイン、またはプロジェクトのエージェントファイルからのサーバーの場合は [Claude Code が削除する認証情報の変数](/docs/ja/mcp#which-variables-a-helper-can-read)なしで実行します。サーバーのエンドポイントが受け付ける `Authorization` の値が出力されることを確認します
* ヘルパーまたはその認証情報のソースを修正した後、`/mcp` でサーバーを選択し、**Reconnect** を選択します

v2.1.248 より前は、ヘルパーが `Authorization` ヘッダーを提供するサーバーに対しても、Claude Code は OAuth の検出を実行していました。この検出は、拒否された認証情報を報告する代わりに `Incompatible auth server: does not support dynamic client registration` で失敗することがありました。

<h3 id="mcp-permission-prompt-tool-not-found">
  MCP の権限プロンプトツールが見つからない
</h3>

実行で最初に権限の判断が必要になった時点で、[`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) に渡したツールが接続済みの MCP ツールの中にありませんでした。サーバーが一度も接続しなかったか、接続済みのサーバーがその名前のツールを公開していないためです。Claude Code はプロンプトを送信するため、[非対話](/docs/ja/headless)の実行は最初のツール呼び出しでこのエラーと終了コード 1 で終了し、リクエストが行われたにもかかわらず回答は生成されません。最初のプロンプトの前に、Claude Code は [`MCP_TIMEOUT`](/docs/ja/env-vars) で設定されるサーバーごとの接続タイムアウト（30 秒）まで、そのサーバーの接続を待機します。v2.1.206 より前は、起動時にサーバーの接続完了を待たなかったため、起動が遅いものの正常なサーバーでもこのエラーが発生していました。

```text theme={null}
Error: MCP tool mcp__permissions__approve (passed via --permission-prompt-tool) not found. Available MCP tools: none
```

`Available MCP tools:` の後のリストには、接続されていた MCP ツールが示されます。

**対処方法:**

* サーバーが起動して接続を維持していることを確認します。同じディレクトリで `claude mcp list` を実行し、サーバーが接続済みとして表示されることを確認します
* ツール名が、サーバーが公開する `mcp__<server>__<tool>` 名と一致していることを確認します
* サーバーの起動に 30 秒以上かかる場合は、[`MCP_TIMEOUT`](/docs/ja/env-vars) の値を増やします

<h3 id="oauth-callback-port-is-already-in-use">
  OAuth コールバックポートがすでに使用されている
</h3>

OAuth でリモート MCP サーバーにサインインすると、Claude Code はサインインのコールバックを受け取るためのローカルリスナーを開始します。そのリスナーが必要とするポートを別のプロセスが保持している場合、サインインはこのメッセージで失敗します。これは主に、[`MCP_OAUTH_CALLBACK_PORT`](/docs/ja/env-vars) 変数または `--callback-port` で[固定のコールバックポート](/docs/ja/mcp#use-a-fixed-oauth-callback-port)を設定している場合に発生します。固定ポートがない場合、Claude Code は利用可能なポートを選択するためです。

```text theme={null}
OAuth callback port <port> is already in use — another process may be holding it. Run `lsof -ti:<port> -sTCP:LISTEN` to find it.
```

Windows では、代わりに `netstat -ano | findstr :<port>` コマンドが提案されます。

**対処方法:**

* メッセージに示されたコマンドを実行してポートを保持しているプロセスを見つけ、停止するか終了するのを待ちます
* 別のプログラムがそのポートを常に必要とする場合は、サーバーに別のリダイレクト URI を登録し、使用している方法に応じて `MCP_OAUTH_CALLBACK_PORT` または `--callback-port` でそのポートを設定します
* その後、たとえば `/mcp` でサーバーを選択して、サインインを再度開始します

<h3 id="no-available-ports-for-oauth-redirect">
  OAuth リダイレクトに利用可能なポートがない
</h3>

[OAuth](/docs/ja/mcp#authenticate-with-remote-mcp-servers) でリモート MCP サーバーにサインインすると、Claude Code はサインインのコールバックを受け取るためのローカルリスナーを開始します。Claude Code がそのためのローカルポートをバインドできない場合、サインインはこのメッセージで失敗します。セキュリティソフトウェアやローカルリスナーを禁止するサンドボックスポリシーなど、マシン上の何かが `127.0.0.1` でのリッスンを妨げています。

```text theme={null}
No available ports for OAuth redirect
```

v2.1.268 より前は、Claude Code はオペレーティングシステムが割り当てるポートにフォールバックしなかったため、自身で選択したポートだけをバインドできない場合にもこのメッセージが表示されていました。これは、Claude Code が選択するポートを含むポート範囲を Hyper-V が予約している Windows ホストで発生することがあります。

**対処方法:**

* セキュリティソフトウェアやサンドボックスポリシーがプロセスの `127.0.0.1` でのリッスンをブロックしていないか確認し、Claude Code がローカルポートをバインドできるように許可します
* その後、たとえば `/mcp` でサーバーを選択して、サインインを再度開始します

<h3 id="security-review-fails-without-origin-head">
  origin/HEAD がないと /security-review が失敗する
</h3>

[`/security-review`](/docs/ja/commands#all-commands) は、ブランチと `origin/HEAD` との差分を取ってレビューのコンテキストを構築します。`origin/HEAD` は、`origin` リモートでどのブランチがデフォルトであるかを記録するローカルの ref です。この ref が存在しない場合、差分を収集する git コマンドが失敗し、レビューは開始前に停止します。

```text theme={null}
Error: Shell command failed for pattern "!`git diff --name-only origin/HEAD...`": [stderr]
fatal: ambiguous argument 'origin/HEAD...': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
```

メッセージには、代わりに `git log` や別の `git diff` が引用されることがあります。Git が `origin/HEAD` を作成するのは、リモートがデフォルトブランチを公開しており、フェッチの refspec がそれを含む場合のみです。コミットのあるリモートを完全に `git clone` した場合はこれに該当します。次の構成では ref が存在しません:

* refspec が狭すぎるフェッチを行う、シングルブランチまたは CI のチェックアウト
* サーバー側の HEAD が、誰もプッシュしていないブランチを指しているリモート
* `origin` リモートがない、または一度もフェッチしていないリポジトリ

Claude Code は、[動的なコンテキストを挿入する](/docs/ja/skills#when-an-injected-command-fails)すべてのスキルで同じエラーを表示し、挿入されたコマンドが失敗するとそのスキルの呼び出しは中止されます。関連する 2 つのメッセージは、コマンドが実行される前に発生します:

* `Shell command permission check failed for pattern "..."`: コマンドの権限チェックで許可されませんでした。[挿入されたコマンドの権限チェック](/docs/ja/skills#permission-checks-on-injected-commands)では、各権限モードでどの結果が中止につながるか、および `allowed-tools` でコマンドを事前承認する方法について説明しています
* ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found``: スキルのフロントマターが、bash のないマシンで bash を要求しています。Git for Windows をインストールするか、フロントマターを `shell: powershell` に変更します。[挿入されたコマンドの実行方法](/docs/ja/skills#how-injected-commands-run)を参照してください

**対処方法:**

* リモートのデフォルトブランチを指定して ref を作成します: `git remote set-head origin <default-branch>`。これは、ローカルの追跡 ref `origin/<default-branch>` が存在する場合に機能します。シングルブランチのクローンのように存在しない場合は、まずブランチをフェッチします。`git remote set-branches --add origin <branch>` を実行し、次に `git fetch origin` を実行してから、set-head コマンドを再実行します。その後、`/security-review` を再実行します。
* ブランチ名を指定したくない場合は、`git fetch origin` を実行してから `git remote set-head origin --auto` を実行します。これはリモートにどのブランチがデフォルトかを問い合わせます。リモートが空である、またはその HEAD が誰もプッシュしていないブランチを指しているためにデフォルトブランチを公開していない場合は、`error: Cannot determine remote HEAD` で失敗します。その場合はブランチ名を明示的に指定してください。クローンがそのブランチをフェッチしない場合は `error: Not a valid ref` で失敗します。先に上記のように refspec を広げてください。
* リポジトリにリモートがない場合は、`git remote add origin <url>` でリモートを追加し、ref を作成する前にフェッチします。リモートが空の場合は、まず `git push -u origin HEAD` でブランチをプッシュし、set-head コマンドでそのブランチ名を指定します。その場合、`origin/HEAD` はプッシュしたばかりのブランチを指すため、ブランチがそこから分岐するまで `/security-review` には空の差分が表示されます。

<h3 id="input-must-be-provided-when-using-print">
  `--print` の使用時には入力を指定する必要がある
</h3>

引数なしの `claude` は、対話 UI を開始するために stdout がターミナルである必要があります。stdout がリダイレクトされている場合や、PowerShell ISE や一部の IDE の出力ペインのようにコンソールが実際のターミナルではない場合、`claude` は代わりに[非対話](/docs/ja/headless)で実行されます。これは `claude -p` と同じモードで、プロンプトが必要です。そのため、フラグを渡していなくてもメッセージには `--print` が示されます。プロンプトを指定せず stdin にも何もパイプせずに `-p`/`--print` を渡した場合も、どこでも同じエラーが発生します。

```text theme={null}
Error: Input must be provided either through stdin or as a prompt argument when using --print
```

**対処方法:**

* 対話的に使用する場合は、実際のターミナルで `claude` を実行します。ISE ではなく Windows Terminal または PowerShell コンソールを、出力ペインではなく IDE の統合ターミナルを使用します
* 1 回限りの使用の場合は、プロンプトを渡します: `claude -p "your question"`、または `echo "your question" | claude -p` でパイプします

<h3 id="claude-code-cant-read-the-keyboard-here">
  Claude Code がここではキーボードを読み取れない
</h3>

[`-p`](/docs/ja/headless) を付けずに `claude` を実行したため[対話セッション](/docs/ja/interactive-mode)が開始されますが、その標準入力がターミナルではありません。何かがパイプまたはリダイレクトしているか、`claude` を起動したプログラムが独自の入力ストリームを提供しています。

対話セッションにはキー入力を読み取るためのターミナルが必要で、ターミナルがない場合の Claude Code の動作はプラットフォームによって異なります:

* **Windows**: Claude Code はインターフェースを開始せずに、メッセージを stderr に出力して終了コード 1 で終了します
* **macOS と Linux**: Claude Code は `/dev/tty` からキー入力を読み取ってセッションを開始し、パイプされたテキストがあれば最初のプロンプトとして使用します。`/dev/tty` を開けない場合にメッセージが表示され、その 1 行目には Windows の文言の代わりに `/dev/tty` が示されます。

Windows では、メッセージは次のようになります:

```text theme={null}
Claude Code can't read the keyboard here: stdin is not a terminal (it is piped, redirected, or supplied by the program that launched claude), and on Windows it can't fall back to the console for input yet.
Run claude directly in Windows Terminal, PowerShell, or Command Prompt, without piping or redirecting its input.
To send text as a prompt and print the reply instead, add -p; it also works with --continue and --resume <session-id> (for example: type notes.md | claude -p --continue).
```

**対処方法:**

* 対話的に作業するには、入力をパイプまたはリダイレクトせずに、ターミナルで直接 `claude` を実行します
* スクリプトからなど、対話インターフェースなしで応答を得るには、`-p` を追加し、`claude -p "your question"` や `echo "your question" | claude -p` のように、プロンプトを引数または stdin で渡します。`--continue` と `--resume <session-id>` でも同じように機能します。

v2.1.287 より前は、Claude Code はこのメッセージを出力する代わりにインターフェースを開始し、画面に何も表示しないか、`Raw mode is not supported` を含むエラーで失敗していました。

代わりに `claude install` の実行中に `Raw mode is not supported` が表示される場合は、[インストール中の `Raw mode is not supported`](/docs/ja/troubleshoot-install#raw-mode-is-not-supported-during-install) を参照してください。

<h3 id="input-contained-only-whitespace">
  入力が空白文字のみだった
</h3>

[非対話モード](/docs/ja/headless)では、Claude Code はスペース、タブ、改行のみで構成されたプロンプトを送信せずに拒否します。API は表示可能なテキストのないメッセージを拒否するためです。表示されるメッセージは、空のプロンプトがどこから来たかによって異なります:

* **`claude -p` のプロンプト引数またはパイプされた stdin**: `claude` は `Error: Input contained only whitespace. Provide a prompt with text through stdin or as a prompt argument when using --print` で終了します
* **実行中の `--input-format stream-json` または [Agent SDK](/docs/ja/agent-sdk/overview) セッションに送信されたメッセージ**: Claude Code はモデルを呼び出さずにターンを終了し、セッションは引き続き使用できます。拒否は情報メッセージとして、またターンの結果テキストとして届きます: `Blank prompt — the message was only whitespace, so nothing was sent to the model.`

v2.1.229 より前は、Claude Code は空白文字のみのメッセージを API に送信し、API はリクエストを 400 エラーで拒否していました。

**対処方法:**

* プロンプトに表示可能なテキストを含めます。スクリプトが変数やファイルからプロンプトを構築する場合は、Claude Code を呼び出す前にソースが空でないことを確認します。

<h3 id="stream-json-input-carried-over-256m-characters-with-no-newline">
  stream-json の入力が改行なしで 256M 文字を超えた
</h3>

プログラムが `claude -p --input-format stream-json` の実行に対して、改行なしで 268,435,456 文字を超える文字を stdin に送信したため、Claude Code はそれ以上入力をバッファリングせずに、このエラーを stderr に出力して終了コード 1 で終了します。メッセージではこの上限を `256M` と表記しています。v2.1.257 より前は、Claude Code はこのような入力を無制限にバッファリングし、プロセスがクラッシュするか強制終了されるまでメモリが増加していました。

```text theme={null}
Error: stream-json input carried over 256M characters with no newline. Each stream-json message must be a single newline-terminated JSON line: either the producer is not newline-terminating its messages, or one message exceeded this budget.
```

改行なしでこれほど長い入力がある場合、通常は送信元がそもそも stream-json の送信元ではないことを意味します。たとえば、誤ってパイプされたバイナリファイルやプレーンなログ出力などです。上限を超える単一のメッセージも同じチェックで失敗します。

**対処方法:**

* stdin にパイプされているものを確認します。[`--input-format stream-json`](/docs/ja/cli-reference#cli-flags) では、すべてのメッセージが改行で終わる 1 行の JSON である必要があります
* 代わりにプレーンテキストを送信するには、`--input-format stream-json` を削除します。`claude -p` はデフォルトで stdin からプレーンテキストのプロンプトを読み取ります

<h3 id="unknown-command">
  Unknown command
</h3>

対話型のターミナルセッションで、このセッションのどのコマンドにも一致しない `/` の名前を送信したため、Claude Code は何も実行せずにその名前を報告します:

```text theme={null}
Unknown command: /hepl. Did you mean /help?
```

Claude Code は、このセッションでメニューに表示される最も近いコマンド名またはエイリアスを提案します。近いものがない場合、メッセージは名前の後で終わります。原因は通常、次のいずれかです:

* `/help` を `/hepl` と入力するなどのタイプミス。[コマンドメニューが入力内容と照合する方法](/docs/ja/commands#how-the-command-menu-matches-what-you-type)では、送信前に近い候補を選択する方法について説明しています
* コマンドは存在するものの、プラットフォーム、プラン、認証方法などの要件を満たしていないため、このセッションでは利用できない。[`/web-setup`](/docs/ja/web-quickstart#web-setup-shows-no-commands-match-or-unknown-command) と [`/schedule`](/docs/ja/routines#schedule-returns-unknown-command) のトラブルシューティング項目では、よくある 2 つのケースを説明しています。一部のコマンドは、組織のポリシーで無効になっている場合に [`Cloud sessions are disabled by your organization's policy`](#cloud-sessions-are-disabled-by-your-organizations-policy) のような独自のメッセージで応答します
* このセッションでインストールまたは接続されていない[プラグイン](/docs/ja/plugins/overview)や [MCP サーバー](/docs/ja/mcp#use-mcp-prompts-as-commands)のコマンド

Claude Code が一致しない `/` の名前にこのように応答するのは、対話型のターミナルセッションのみです。それ以外のすべてのセッションでは、コマンドが実行されなかったことを示す注記と、そのセッションで Claude が実行できるコマンドの一覧を添えて、プロンプトを通常のメッセージとして Claude に送信します。これらのセッションには次のものが含まれます:

* `-p` の実行
* [Agent SDK](/docs/ja/agent-sdk/overview) アプリケーション
* [デスクトップアプリ](/docs/ja/desktop)の Code タブ
* [VS Code 拡張機能](/docs/ja/vs-code)のチャットパネル
* [クラウドセッション](/docs/ja/claude-code-on-the-web)と[ルーティン](/docs/ja/routines)

これらのセッションで実行できない組み込みコマンドについては、Claude Code は Claude に送信せずに、そのコマンドが利用できないことを応答します。v2.1.274 より前は、一致しない名前を Claude に送信していたのはクラウドセッションとルーティンのみでした。v2.1.273 より前は、これらも `Unknown command` と応答していました。

Claude Code は、`/` で始まるすべてのプロンプトをコマンドとして扱うわけではありません。`/` の後の最初の単語が、Lean のドキュメントコメントを開始する `/--` のように句読点で始まる場合、または `/var/log/syslog` のようなパスである場合は、プロンプトを通常のメッセージとして Claude に送信します。

v2.1.236 より前は、入力した名前に近い候補がコマンドメニューに表示されている状態で `Enter` を押すと、Claude Code はその候補を実行していました。そのため、`/hepl` のようなタイプミスでは、このメッセージが表示される代わりに `/help` が実行されていました。

**対処方法:**

* 提案された名前を実行するか、`/` に続けて名前の一部を入力して、このセッションで利用できるものを確認します
* ドキュメントに記載されているコマンドが Claude Code で不明と報告される場合は、[コマンドリファレンス](/docs/ja/commands)でそのコマンドの行を確認し、示されている要件を確認します

<h3 id="diff-is-too-large-for-ultrareview">
  差分が大きすぎて ultrareview を実行できない
</h3>

コミットされていない変更とステージされた変更を含む、ブランチとベースブランチの間の差分が [ultrareview](/docs/ja/ultrareview) のサイズ上限を超えているため、`/code-review ultra` と `claude ultrareview` サブコマンドはクラウドセッションの開始前にレビューを拒否します。拒否されたレビューは無料実行回数を消費せず、使用クレジットも請求されません。メッセージには、適用されている上限、差分のサイズ、変更行数が最も多いファイルが示されます。v2.1.216 より前は、メッセージには生の差分統計のみが表示されていました。

```text theme={null}
Diff is too large for ultrareview: 812 files, 96,410 lines changed (limits: 500 files, 8,000 lines). Largest files: package-lock.json (41,904 lines), dist/bundle.js (18,210 lines), src/generated/api.ts (9,876 lines). Pass a closer base branch (`/code-review ultra <branch>`) to narrow the scope, or split the change.
```

プルリクエストのレビューにも同じ上限が適用されます。その場合のメッセージは `PR #<N> is too large for ultrareview` で始まり、PR のファイル数と行数が示されます。

**対処方法:**

* `/code-review ultra develop` のように、作業により近いベースブランチを渡して、レビューがそのブランチとの差分のみを対象とするようにします
* 変更をより小さなブランチに分割し、それぞれをレビューします。メッセージに示されたファイルが変更行数の大部分を占めているため、まずそれらを別のブランチに移動します。

<h3 id="could-not-find-merge-base-with-the-base-branch">
  ベースブランチとの merge-base が見つからない
</h3>

`/code-review ultra` と `claude ultrareview` サブコマンドは、ブランチとベースブランチの間の差分をレビューします。これには 2 つが共有するコミットが必要です。`git merge-base` が共有コミットを見つけられない場合、Claude Code はクラウドセッションの開始前にレビューを拒否します。Claude Code が完全であることを確認でき、少なくとも 1 つのブランチがあるクローンでは、拒否する代わりに[追跡されているすべてのファイルのレビュー](/docs/ja/ultrareview#diff-limits-and-fallbacks)にフォールバックします。この拒否が表示されるのは、ベースブランチがまったく見つからない場合、Claude Code がクローンの完全性を確認できない場合、または SHA-256 オブジェクト形式など、ツリー全体の差分が不可能なまれなリポジトリの場合です。

```text theme={null}
Could not find merge-base with main. Pass the base branch explicitly (e.g. `/code-review ultra develop`) or make sure you're in a git repo with a main branch.
```

最初の文の後のヒントは、Claude Code が観察した内容によって異なります:

* **ベースブランチを渡さなかった場合**: Claude Code はリポジトリのデフォルトブランチと比較し、上記の例のようにベースを明示的に渡すよう提案します
* **すでにクローンにあるベースブランチを渡した場合**: ヒントは ``Make sure <branch> exists locally or on origin (try `git fetch origin <branch>`)`` となります
* **クローンにないベースブランチを渡した場合**: Claude Code は比較の前に origin からそれをフェッチしました。ヒントは ``<branch> was fetched from origin but shares no history with HEAD. If another branch is your real base, pass it explicitly (`/code-review ultra <branch>`)`` となります。Claude Code がクローンが shallow かどうかを判断できない場合は、代わりに `git fetch --unshallow origin` を提案します。v2.1.221 より前は、フェッチしたすべてのベースブランチに対してヒントが `git fetch --unshallow origin` を提案していましたが、完全なクローンではこのコマンドは `fatal: --unshallow on a complete repository does not make sense` で失敗します。

**対処方法:**

* 別のブランチが実際のベースである場合は、明示的に渡します: `/code-review ultra <branch>`
* クローンに完全な履歴がない可能性がある場合は、`git fetch --unshallow origin` を実行してからレビューを再実行します

<h3 id="your-checkout-has-no-branches">
  チェックアウトにブランチがない
</h3>

チェックアウトには、コミットがあってもブランチがない場合があります。`git init` の後に `git fetch <url>` と `git checkout FETCH_HEAD` を実行すると、ref のない detached HEAD になります。Claude Code は [ultrareview](/docs/ja/ultrareview) のためにリポジトリを git バンドルとしてパッケージ化してアップロードしますが、ブランチやその他の ref がないリポジトリはバンドルできないため、`/code-review ultra` と `claude ultrareview` サブコマンドはクラウドセッションの開始前にレビューを拒否します。

```text theme={null}
Your checkout has no branches (detached HEAD only), which cloud review can't bundle. Create one first — `git checkout -b <name>` — then rerun /code-review ultra.
```

v2.1.221 より前は、Claude Code はこのチェックアウト内の追跡されているすべてのファイルをレビューしようとし、アップロードが失敗していました。

**対処方法:**

* `git checkout -b <name>` で現在のコミットにブランチを作成してから、レビューを再実行します

<h3 id="no-github-account-is-connected-to-your-claude-account">
  Claude アカウントに GitHub アカウントが接続されていない
</h3>

`/code-review ultra <PR#>` または `claude ultrareview <PR#>` を実行しました。Claude Code はクラウドセッションを作成する前に、[Claude アカウントに接続された GitHub アカウント](/docs/ja/ultrareview#review-a-pull-request)が PR のリポジトリにアクセスできるかをサーバーに確認します。アカウントが接続されていないか接続の有効期限が切れているため、クラウドでのクローンが失敗することになり、Claude Code は起動を拒否します。拒否された起動では、無料実行回数は消費されず、使用クレジットも請求されません。

```text theme={null}
Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected (or the connection expired). To fix: run /web-setup to reuse your GitHub CLI login, or connect an account at https://claude.ai/connect-github — then re-run /code-review ultra 1234 (allow a minute after connecting).
```

セッションで [`/web-setup`](/docs/ja/web-quickstart#connect-from-your-terminal) が利用できない場合、メッセージには claude.ai のリンクのみが示されます。

**対処方法:**

* `/web-setup` を実行して GitHub CLI のログインを Claude アカウントに接続するか、[claude.ai/connect-github](https://claude.ai/connect-github) でアカウントを接続します
* 接続してから 1 分ほど待って、レビューを再実行します

v2.1.248 より前は、Claude Code は起動前にこれを確認していませんでした。

<h3 id="your-connected-github-account-cant-see-the-repository">
  接続された GitHub アカウントがリポジトリを参照できない
</h3>

`/code-review ultra <PR#>` または `claude ultrareview <PR#>` を実行しましたが、[Claude アカウントに接続された GitHub アカウント](/docs/ja/ultrareview#review-a-pull-request)が PR のリポジトリを読み取れないため、クラウドでのクローンが失敗することになり、Claude Code は起動を拒否します。拒否された起動では、無料実行回数は消費されず、使用クレジットも請求されません。

```text theme={null}
Your connected GitHub account can't see <owner>/<repo> — usually the Claude GitHub app isn't installed on <owner> or wasn't granted this repo (web-connected accounts need it for private repos), or a different GitHub account is connected. To fix: run /web-setup to reuse your GitHub CLI login, or install the app at https://github.com/apps/claude/installations/new — then re-run /code-review ultra 1234.
```

セッションで [`/web-setup`](/docs/ja/web-quickstart#connect-from-your-terminal) が利用できない場合、メッセージにはアプリのインストールのみが示されます。

**対処方法:**

* ローカルの `gh` CLI がリポジトリを読み取れる場合は、`/web-setup` を実行してそのログインを Claude アカウントに接続します
* 変更後にレビューを再実行します

v2.1.248 より前は、Claude Code は起動前にこれを確認していませんでした。

<h3 id="the-github-app-preflight-failed-transiently">
  GitHub App の事前チェックが一時的に失敗した
</h3>

ローカルリポジトリから[クラウドセッション](/docs/ja/claude-code-on-the-web)を開始しましたが、2 つのステップが同時に失敗しました。Claude Code はリポジトリのバンドルをビルドまたはアップロードできませんでした。アップロードの前に、クラウドサービスが GitHub からリポジトリをクローンできるかを確認しましたが、そのチェックは明確な結果ではなく、ネットワークエラー、タイムアウト、一時的なサーバーエラーなど、再試行で解消される可能性のあるエラーで終わりました。完全なメッセージは、`Could not upload repo bundle (<error>)` のようにバンドルを停止させた原因で始まり、事前チェックの文で終わります:

```text theme={null}
Could not upload repo bundle (<error>). The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead
```

**対処方法:**

* しばらくしてからコマンドを再実行します。GitHub のチェックに合格すると、Claude Code は GitHub のクローンからセッションを開始できるため、アップロードの失敗によって起動がブロックされなくなります
* 再試行しても失敗し続ける場合は、メッセージの冒頭にアップロードを停止させた原因が示されています。その原因が修正可能なものであれば、修正することでローカルリポジトリからセッションを開始できるようになります

v2.1.251 より前は、GitHub のチェックが一時的に失敗しただけの場合でも、Claude Code はメッセージの末尾に `Please set up GitHub on https://claude.ai/code` を表示していましたが、セットアップのアドバイスでは一時的な失敗は解消できません。

<h3 id="the-repository-upload-cant-follow-a-git-setting">
  リポジトリのアップロードが git 設定に従えない
</h3>

[ローカルリポジトリをアップロードするクラウドセッション](/docs/ja/claude-code-on-the-web#send-local-repositories-without-github)、またはブランチの [ultrareview](/docs/ja/ultrareview) を開始しましたが、ファイルにどの属性ルールが適用されるかを決定する git の設定のいずれかにアップロードが従えません。アップロードを続行してルールを見落とすと、clean フィルターで暗号化されるファイルなど、git が保存前に変換するファイルが、ディスク上のままの状態でクラウドに届く可能性があります。Claude Code は代わりにアップロードを拒否し、何もアップロードされません:

```text theme={null}
Not uploading this working tree: core.ignoreCase (which decides whether .gitattributes patterns match file names regardless of letter case) is set in <file>, and the upload cannot follow that setting, so a file git would change before storing it (to encrypt it, for example) could be uploaded as it is on disk. Move the core.ignoreCase line into this repository’s .git/config or directly into your ~/.gitconfig, then retry.
```

メッセージには設定とその設定場所が示され、該当するケースの対処方法で終わります。`core.attributesFile` と `attr.tree` でも同じ拒否が表示され、それぞれに独自の対処方法があります。

メッセージには、git の設定が `include` または `includeIf` ディレクティブで読み込む設定ファイルが示される場合があります。これは、そのディレクティブの条件がこのリポジトリに該当しない場合でも同様です。

**対処方法:**

* メッセージの最後の文に示された対処方法を適用します

<h3 id="github-isnt-connected-to-your-claude-account">
  GitHub が Claude アカウントに接続されていない
</h3>

たとえば `/autofix-pr` を使用して、ローカルリポジトリから[クラウドセッション](/docs/ja/claude-code-on-the-web)を開始しました。Claude アカウントに GitHub アカウントが接続されていないか接続の有効期限が切れているため、Claude Code は起動を拒否します:

```text theme={null}
GitHub isn't connected to your Claude account, so this repository can't be cloned in the cloud. Run /web-setup to connect with your GitHub CLI login, or connect on the web at https://claude.ai/connect-github
```

[`/schedule`](/docs/ja/routines) でルーティンを作成する場合、同じメッセージがリポジトリ名を示すセットアップの注記として表示されます。この注記はルーティンの作成をブロックしません。

**対処方法:**

* `/web-setup` を実行して GitHub CLI のログインを Claude アカウントに接続するか、[claude.ai/connect-github](https://claude.ai/connect-github) でアカウントを接続します。2 つの違いについては、[GitHub の認証オプション](/docs/ja/claude-code-on-the-web#github-authentication-options)を参照してください。
* 接続してから 1 分ほど待って、コマンドを再実行します

v2.1.268 より前は、Claude Code はこれを Claude GitHub App のチェックの一時的な失敗として報告し、再試行またはアプリのインストールを提案していましたが、どちらも GitHub アカウントを接続するものではありません。

<h3 id="a-github-organization-policy-is-blocking-claude">
  GitHub 組織のポリシーが Claude をブロックしている
</h3>

Claude Code のプロンプトで、[`/autofix-pr`](/docs/ja/claude-code-on-the-web#auto-fix-pull-requests) などのクラウドセッションを開始するコマンドを実行しました。Claude Code はセッションを作成する前に GitHub 上のリポジトリに対する Claude のアクセスを確認しますが、GitHub 組織に Claude をブロックするポリシーがあるため、GitHub がこれを拒否しました。Claude Code はそこで処理を停止し、該当するポリシーを示すメッセージを表示します。

IP 許可リストがアクセスをブロックしている場合、メッセージは次のようになります。

```text theme={null}
Your GitHub organization has an IP allowlist that is blocking Claude. Add Claude's IP ranges to your GitHub allowlist.
```

シングルサインオンがブロックしている場合、メッセージは次のようになります。

```text theme={null}
Your GitHub organization requires single sign-on. Disconnect and reconnect GitHub on the Connectors page in Claude on the web, click Authorize next to your organization when GitHub asks, then try again.
```

Microsoft Entra ID の条件付きアクセスポリシーがブロックしている場合、メッセージは次のようになります。

```text theme={null}
Your GitHub organization's identity provider (Microsoft Entra ID) has a Conditional Access policy that is blocking Claude. Ask your GitHub Enterprise or Entra ID admin to allow Claude in that policy.
```

**対処方法:**

* **IP 許可リスト**: GitHub の組織または Enterprise のオーナーに、Anthropic の送信元 IP アドレスを許可するよう依頼してください。アドレスと変更する GitHub の設定については、[GitHub の許可リストとファイアウォール](/docs/ja/network-config#github-allow-lists-and-firewalls)を参照してください。
* **シングルサインオン**: [claude.ai/customize/connectors](https://claude.ai/customize/connectors) で GitHub の接続を解除してから、再度接続します。GitHub から求められたら、組織の横にある **Authorize** をクリックして、新しい接続がその組織のシングルサインオンに対して認可されるようにします。
* **条件付きアクセスポリシー**: GitHub Enterprise または Microsoft Entra ID の管理者に、そのポリシーで Claude を許可するよう依頼してください
* 変更後、コマンドを再度実行してください

<h3 id="single-sign-on-authorization-needed">
  シングルサインオンの認可が必要
</h3>

[`/install-github-app`](/docs/ja/github-actions#quick-setup) を実行し、SAML シングルサインオンを強制している組織のリポジトリを選択しました。Claude Code はセットアップの前に GitHub CLI でリポジトリへのアクセスを確認しますが、`gh` トークンがまだその組織に対して認可されていないため、GitHub がその確認を拒否しました。ウィザードは、認可の手順とともに次の警告を表示します。

```text theme={null}
Single sign-on authorization needed
<owner>/<repo> belongs to an organization that enforces SAML single sign-on, and your GitHub CLI token isn't authorized for it yet.
```

**対処方法:**

* `gh auth refresh -h github.com -s repo,workflow` を実行して `repo` と `workflow` スコープで GitHub CLI のログインを再認可し、GitHub からシングルサインオンを求められたら組織を認可してください
* `GH_TOKEN` の個人用アクセストークンで認証している場合は、[github.com/settings/tokens](https://github.com/settings/tokens) を開き、トークンの **Configure SSO** を選択して組織を認可してください
* `/install-github-app` を再度実行してください

v2.1.273 より前では、この状況で Claude Code は代わりに `Admin permissions required` という警告を表示していました。

<h3 id="failed-to-resume-the-conversation">
  会話の再開に失敗した
</h3>

[`claude --resume` ピッカー](/docs/ja/sessions#use-the-session-picker)から選択したセッションの保存済みトランスクリプトを Claude Code が読み取れなかったか処理できなかったため、部分的に読み込まれた状態で続行するのではなく、プロセスを終了します。メッセージには再試行するためのコマンドが含まれています。

```text theme={null}
Failed to resume the conversation.
Run claude --resume <session-id> to retry, or claude to start a new session.
```

Claude Code はメッセージを表示した後、終了コード 1 で終了します。実行中のセッション内の `/resume` ピッカーの場合は、代わりに会話内で `Failed to resume conversation` と報告され、現在のセッションは実行を続けます。v2.1.216 より前では、`claude --resume` ピッカーからの再開に失敗すると、このメッセージを表示する代わりに `Resuming conversation…` スピナーのまま無期限に止まっていました。

**対処方法:**

* メッセージに含まれるセッション ID を指定して `claude --resume <session-id>` を実行し、再試行してください
* v2.1.285 より前のバージョンで再試行が同じように失敗する場合は、`claude update` を実行してから再度再開してください。これらのバージョンでは、保存済みトランスクリプトに読み取れないエントリが含まれていると再開に失敗します。
* 再試行が再び失敗する場合は、`claude` を実行して新しいセッションを開始してください

<h3 id="no-conversation-found-with-the-session-id">
  セッション ID に一致する会話が見つからない
</h3>

`claude --resume <session-id>` にセッション ID を渡しましたが、一致する保存済みトランスクリプトがありませんでした。

```text theme={null}
No conversation found with session ID: <session-id>
```

Claude Code はメッセージを表示した後、終了コード 1 で終了します。Claude Code は ID を探す際、[まず現在のプロジェクトを検索し、次にこのマシン上の他のすべてのプロジェクトを検索します](/docs/ja/sessions#resume-a-session)。v2.1.223 より前では、検索は現在のプロジェクトディレクトリとその git worktree で止まっていたため、セッションが最後に作業していたディレクトリから再開してください。

主な原因:

* **ID の入力ミス**: 非対話型の実行の場合、ID は [`--output-format json` の出力](/docs/ja/headless#get-structured-output)の `session_id` フィールドです
* **トランスクリプトの削除**: Claude Code は[保持期間](/docs/ja/sessions#where-transcripts-are-stored)（デフォルトは 30 日）の経過後、[保持期間に基づく削除ルール](/docs/ja/claude-directory#cleaned-up-automatically)に従ってトランスクリプトを削除します
* **別のマシン**: Claude Code はトランスクリプトをローカルに保存するため、セッションを実行したマシンで再開してください
* **重複したコピー**: `~/.claude/projects` 配下のプロジェクトディレクトリをコピーしたことで 2 つのトランスクリプトが同じ ID を持つ場合、Claude Code はどちらか一方を任意に再開するのではなく、このメッセージを報告します

**対処方法:**

* 対話型セッションの場合は、`claude --resume` で[セッションピッカー](/docs/ja/sessions#use-the-session-picker)を開き、`Ctrl+A` を押してこのマシン上のすべてのプロジェクトに範囲を広げてから、セッションを選択してください
* `claude -p` または [Agent SDK](/docs/ja/agent-sdk/overview) で作成したセッションはピッカーに表示されないため、元の実行で出力された `session_id` と ID を照合し直してください

<h3 id="windows-reported-an-error-ebadf">
  Claude Code がこのセッションのトランスクリプトファイルを読み取った際に Windows がエラー（EBADF）を報告した
</h3>

Windows でセッションを再開した際、保存済みの[トランスクリプトファイル](/docs/ja/sessions#where-transcripts-are-stored)は正常に開けたものの、その後の読み取りがシステムエラー EBADF で失敗しました。システムエラーからは読み取りが失敗した理由がわからないため、メッセージでは考えられる原因と試すべきことを提示します。

```text theme={null}
Windows reported an error (EBADF) when Claude Code read this session's transcript file, although the file had opened normally. This can happen when other software intercepts file reads — security, encryption or endpoint-management tools, for example. If it keeps happening for this conversation, try excluding the folder that holds Claude Code's session transcripts from such software (the .claude folder in your user profile, unless the app or CLAUDE_CONFIG_DIR points Claude Code elsewhere), or adding Claude Code to its allowed applications, then resume again.
```

このメッセージは、`Failed to resume session <session-id>` などのコマンド自体の失敗を示す行の後に表示されます。`claude --resume` または [`claude -p`](/docs/ja/headless) コマンドは、これを表示した後に終了コード 1 で終了します。セッション内で `/resume` を実行した場合は、現在のセッションは実行を続けます。

**対処方法:**

* セキュリティ、暗号化、エンドポイント管理ツールなど、ファイルの読み取りをスキャンまたはインターセプトするソフトウェアの対象から、セッションのトランスクリプトを保存しているフォルダを除外してください。トランスクリプトはデフォルトでは `%USERPROFILE%\.claude\projects` 配下に、または [`CLAUDE_CONFIG_DIR`](/docs/ja/env-vars) が指定するディレクトリ配下に保存されています
* 除外を追加できない場合は、代わりにそのソフトウェアの許可アプリケーションに Claude Code を追加してください
* セッションを再度再開してください

v2.1.282 より前では、この失敗は説明なしで発生していました。`claude --resume <session-id>` は `Failed to resume session <session-id>` で終了し、`-p` の実行では `Failed to resume session: EBADF: bad file descriptor, read` のようなシステムエラーのテキストのみが出力されていました。

<h3 id="cannot-switch-renderers-in-this-session">
  このセッションではレンダラーを切り替えられない
</h3>

レンダラーを切り替えると、Claude Code はプロセスを再起動します。Claude Code が再起動を拒否するセッションで [`/tui`](/docs/ja/fullscreen#enable-fullscreen-rendering) を実行したため、切り替えは行われず、何も保存されません。表示されるメッセージによって原因がわかります。

* `Cannot switch renderers while work is running in the background`: バックグラウンドシェルやサブエージェントなど、再起動すると破棄されてしまうバックグラウンド処理が実行中です。処理が終了するまで待つか、[`/tasks`](/docs/ja/commands) で停止してから、`/tui fullscreen` または `/tui default` を再度実行してください
* `Cannot switch renderers in this session`: セッションに、Claude Code が再起動後のプロセスに引き継げない制限があります。v2.1.234 より前では、Claude Code はそれでも再起動し、再起動後のセッションはそれらの制限なしで実行されていました

制限に関するメッセージでは、括弧内の部分に Claude Code が検出した制限が示されます。

```text theme={null}
Cannot switch renderers in this session — it has restrictions a restart can't carry over (permission rules set for this session only). Nothing was changed. Running /tui fullscreen in a session started without them switches every later session too.
```

メッセージの括弧内に表示される可能性のある各理由:

* `launch flags: a custom system prompt, a tool allowlist, or restricted settings`: Claude Code が再起動後のプロセスに引き継がないフラグを指定してセッションを開始しました。これには [`--system-prompt`](/docs/ja/cli-reference#cli-flags)、`--system-prompt-file`、`--append-system-prompt-file`、[`--tools`](/docs/ja/cli-reference#cli-flags) の許可リスト、[`--setting-sources`](/docs/ja/cli-reference#cli-flags)、[`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) が含まれます
* `permission rules set for this session only`: フックまたは SDK の呼び出し元からの[権限の更新](/docs/ja/hooks#permission-update-entries)によって、`session` を宛先とする拒否ルールまたは確認ルールが追加されました。セッションスコープの許可ルールでは拒否は発生しません。再起動するとそれらは破棄され、Claude Code は代わりに再度確認を求めます
* `ask-before-running rules with no command-line form`: フックまたは SDK の呼び出し元からの権限の更新によって、Claude Code が `--allowed-tools` および `--disallowed-tools` として引き継ぐルールに加えて確認ルールが追加されました。確認ルールに対応するフラグは存在しません
* `permission rules a command line cannot carry intact` および `added directories a command line cannot carry intact`: 権限の更新によって、セッションの途中でルールまたはディレクトリパスが追加されました。再起動後のプロセスのコマンドラインでは、そのテキストを同じ値として引き継ぐことができません

**対処方法:**

* それらの制限なしで開始したセッションで `/tui fullscreen` を実行するか、元に戻す場合は `/tui default` を実行してください。Claude Code はそのセッションで [`tui` 設定](/docs/ja/settings-reference#tui)を保存します

<h3 id="couldnt-open-claude-desktop">
  Claude Desktop を開けなかった
</h3>

セッション内で [`/desktop`](/docs/ja/desktop#coming-from-the-cli) またはそのエイリアスである `/app` を実行したか、シェルで [`claude --desktop`](/docs/ja/cli-reference#cli-flags) を実行しましたが、Claude Code が Claude Desktop を開くために使用するシステムコマンドが失敗しました。`/desktop` の場合、セッションはターミナルに残ります。`claude --desktop` の場合は、`Error:` プレフィックスなしでメッセージを出力し、ステータス 1 で終了します。

括弧内のテキストは失敗したコマンドを示し、終了ステータスとエラー出力の最初の行が生成された場合はそれらも含まれます。macOS ではそのコマンドはこの例のように `open` で、Windows では `rundll32` です。

```text theme={null}
Error: Couldn't open Claude Desktop (`open` exited 1: LSOpenURLsWithRole() failed for the URL claude://resume?session=<session-id> with error -10814). Open Claude Desktop and try again.
```

**対処方法:**

* Claude Desktop を自分で開いてから、`/desktop` または `claude --desktop` を再度実行してください
* 失敗したコマンドの完全なエラー出力を確認するには、`/debug` でデバッグログをオンにして `/desktop` を再度実行するか、`claude --desktop --debug-file <path>` を実行してから、デバッグログを確認してください

v2.1.285 より前では、メッセージの末尾は `Open Claude Desktop and run /desktop again.` でした。v2.1.275 より前では、メッセージは `Failed to open Claude Desktop. Please try opening it manually.` で、何が失敗したかは示されていませんでした。

<h3 id="terminal-setup-left-your-zed-keymap-unchanged">
  /terminal-setup が Zed のキーマップを変更しなかった
</h3>

Zed で [`/terminal-setup`](/docs/ja/terminal-config#enter-multiline-prompts) を実行しましたが、Claude Code が Zed の `keymap.json` の更新を完了できなかったため、ファイルをそのままにしました。

各メッセージにはキーマップのパスが示され、末尾には自分で追加するためのキーボードショートカットのブロックが含まれます。

```text theme={null}
Couldn't update your Zed keymap, so it was left unchanged.
To add the binding yourself, add this block to the keymap array in <path to keymap.json>:
{ "context": "Terminal", "bindings": { "shift-enter": ["terminal::SendText", "\u001b\r"] } }
```

メッセージの最初の行が原因を示します。

* `Couldn't read your Zed keymap, so it was left unchanged.`: ファイルの権限などの理由で、Claude Code がファイルを読み取れませんでした
* `Your Zed keymap isn't a readable list of keybindings, so it was left unchanged.`: ファイルは読み取れましたが、`//` コメントや末尾のカンマを許容しても、キーボードショートカットのブロックの配列として解析できません
* `Couldn't back up your Zed keymap; not modifying it.`: Claude Code がファイルを隣の `.bak` バックアップにコピーできなかったため、何も変更しませんでした
* `Couldn't update your Zed keymap, so it was left unchanged.`: マージした結果が、そのショートカットを含む有効なキーマップであることを検証できなかったため、Claude Code は書き込まずに破棄しました。キーが重複したキーボードショートカットのブロックがあると、これが発生することがあります

**対処方法:**

* メッセージに示されたパスにある `keymap.json` のトップレベルの配列に、メッセージ内のブロックをコピーしてください
* `isn't a readable list of keybindings` の場合は、構文エラーを修正するか、ファイルのトップレベルの値を配列にしてから、`/terminal-setup` を再度実行してください

v2.1.247 より前では、`/terminal-setup` は `//` コメントや末尾のカンマを使用した Zed のキーマップを解析できず、ショートカットがインストールされたと報告しながら、ファイル全体を自身のショートカットのみで置き換えていました。以前のバージョンで置き換えられたキーマップを復元するには、[複数行のプロンプトを入力する](/docs/ja/terminal-config#enter-multiline-prompts)で説明されている `.bak` バックアップファイルを使用してください。

<h3 id="skill-usage-reports-are-not-available-on-this-connection">
  この接続ではスキルの使用状況レポートを利用できない
</h3>

スマートフォンやブラウザから [Remote Control](/docs/ja/remote-control) 経由で [`/skill-doctor`](/docs/ja/skills#find-unused-skills) を実行しました。Claude Code はスキルの使用状況レポートを Remote Control 経由で送信せず、代わりに次のメッセージで応答します。

```text theme={null}
Skill usage reports are not available on this connection.
```

**対処方法:**

* セッションを実行しているマシンのターミナルで `/skill-doctor` を実行するか、そのマシンで `claude -p "/skill-doctor"` を実行してください

<h3 id="custom-output-styles-cant-be-selected-over-remote-control">
  カスタム出力スタイルは Remote Control 経由では選択できない
</h3>

モバイルアプリまたは Web から [Remote Control](/docs/ja/remote-control) 経由で [`/output-style`](/docs/ja/output-styles#change-your-output-style) を実行したか、セッションに中継されたメッセージでそのコマンドが届きました。このようなターンはアカウントの所有者から送られたものではない可能性があるため、Claude Code はそのターンでは[組み込みスタイル](/docs/ja/output-styles#built-in-output-styles)のみを一覧表示・選択し、コマンドがスタイルを一覧表示したとき、または指定された名前を認識できなかったときには常にこの通知を追加します。[カスタムスタイル](/docs/ja/output-styles#create-a-custom-output-style)の名前を指定した場合も、存在しない名前と同じ応答が返されます。

```text theme={null}
Custom output styles can't be selected over Remote Control or from a relayed message. Select one in the session itself, or pick a built-in style here.
```

**対処方法:**

* 組み込みスタイルを選択してください（例: `/output-style concise`）
* カスタムスタイルを使用するには、プロジェクトの `.claude/settings.local.json` で [`outputStyle`](/docs/ja/settings-reference#outputstyle) を設定するか、セッション自体にターミナルがある場合はそこで `/output-style <style>` を実行してください

<h3 id="output-styles-are-saved-to-local-settings-which-this-session-doesnt-load">
  出力スタイルはこのセッションが読み込まないローカル設定に保存される
</h3>

設定ソースから `local` を除外しているセッションで、`/output-style <style>` または `/config outputStyle=<style>` を使って[出力スタイル](/docs/ja/output-styles)を切り替えようとしました。たとえば、[`settingSources`](/docs/ja/agent-sdk/typescript#options) で `"local"` を除外している [Agent SDK](/docs/ja/agent-sdk/typescript) のセッションや、`local` を除外した [`--setting-sources`](/docs/ja/cli-reference#cli-flags) の値で開始した CLI セッションが該当します。どちらのコマンドもスタイルを `.claude/settings.local.json` に保存しますが、このようなセッションはこのファイルを読み込まないため、Claude Code は効果のない設定を書き込むのではなく、処理を拒否します。

```text theme={null}
Output styles are saved to local settings (.claude/settings.local.json), which this session doesn't load, so the style can't be changed here.
```

**対処方法:**

* セッションの設定ソースに `local` を追加してから、再度切り替えてください
* プロジェクトの `.claude/settings.json` や `~/.claude/settings.json` など、セッションが読み込む設定ファイルで [`outputStyle`](/docs/ja/settings-reference#outputstyle) キーを設定してください。TypeScript SDK では、代わりにインラインの `settings` オブジェクト内で `outputStyle` を設定します。[出力スタイルを有効にする](/docs/ja/agent-sdk/modifying-system-prompts#activate-an-output-style)を参照してください

<h3 id="recap-only-runs-when-you-ask-for-it-yourself">
  /recap は自分で要求した場合にのみ実行される
</h3>

[`/recap`](/docs/ja/interactive-mode#session-recap) のリクエストがユーザー自身の入力から送られたものではありませんでした。Slack、Teams、または[プロジェクト](/docs/ja/claude-projects)のスレッドからセッションに中継されたメッセージで届いたか、[ルーティン](/docs/ja/routines)や別のプログラムが送信したプロンプトで届きました。

中継されたメッセージは、自分で書いたものであっても通知の対象になります。Claude Code は、中継されたメッセージや自動化されたメッセージがセッションを実行しているアカウントの本人から送られたものかどうかを判別できないため、要約の代わりに次の通知で応答します。

```text theme={null}
/recap only runs when you ask for it yourself in this session: from the terminal, the Claude app or claude.ai/code, or over Remote Control. A message relayed from Slack, Teams or a project thread, or sent by a routine or another program, can't request it.
```

`claude -p` に渡した `/recap` や、自分の [Agent SDK](/docs/ja/agent-sdk/overview) アプリケーションが起動したセッションに送信した `/recap` は、ユーザー自身の入力として扱われます。

**対処方法:**

* セッションを自分で開き、そこで `/recap` を実行してください。実行場所は、そのセッションのターミナル、[デスクトップアプリ](/docs/ja/desktop)または[モバイルアプリ](/docs/ja/mobile)、[claude.ai/code](https://claude.ai/code)、または [Remote Control](/docs/ja/remote-control) 経由です
* ルーティンや別のプログラムが送信した場合は、そのプロンプトから `/recap` を削除してください

<h2 id="plugin-errors">
  プラグインエラー
</h2>

これらのエラーは、[プラグイン](/docs/ja/plugins/overview)と[マーケットプレイス](/docs/ja/plugins/overview)の設定から発生します。このページのメッセージを生成しないプラグインの問題（マーケットプレイス URL が読み込まれない、またはプラグインがインストールされても表示されないなど）については、[プラグインのトラブルシューティング](/docs/ja/plugins/troubleshooting)を参照してください。

<h3 id="plugin-eval-is-currently-in-early-access">
  plugin eval は現在早期アクセス中です
</h3>

[`claude plugin eval`](/docs/ja/plugin-evals)または `claude plugin eval init` を実行し、何もする前に終了コード 1 で以下のいずれかのメッセージで終了しました：

```text theme={null}
`plugin eval` is currently in early access
```

```text theme={null}
`plugin eval` is currently unavailable
```

最初のメッセージは、ビルドが v2.1.269 より古いことを意味します。これはコマンドが一般的に利用可能になった最初のバージョンです。2 番目のメッセージは、Anthropic がサーバー側でコマンドをオフにしたことを意味します。マシン上の何もそれをオンに戻しません。

**対処方法：**

* `claude --version` を実行してから `claude update` を実行し、新しいセッションでコマンドを再度実行してください。[プラグイン eval の要件](/docs/ja/plugin-evals#requirements)を参照してください
* 現在のビルドで 2 番目のメッセージが表示される場合は、別の `claude update` の後で後で再度試してください

<h3 id="marketplace-is-registered-from-an-untrusted-source">
  マーケットプレイスが信頼されていないソースから登録されています
</h3>

マーケットプレイスは、[公式 Anthropic マーケットプレイス用に予約されている](/docs/ja/plugins/marketplace-reference#marketplace-file)名前で登録されていますが、登録されたソースは `anthropics` GitHub リポジトリではありません。Claude Code は、マーケットプレイスを読み込むか更新するたびに予約名を再確認するため、マーケットプレイスとそこからインストールされたプラグインの読み込みが停止します。v2.1.205 より前では、名前が予約される前に登録されたエントリは読み込みを続けていました。

```text theme={null}
Marketplace "claude-community" is registered from an untrusted source: The name 'claude-community' is reserved for official Anthropic marketplaces. Only repositories from 'github.com/anthropics/' can use this name. To fix it, remove the marketplace and re-add it from the official source.
```

ソースが GitHub リポジトリまたは Git URL ではなく、ローカルディレクトリなどのマーケットプレイスの場合、中央の文は `can only be used with GitHub sources from the 'anthropics' organization` の代わりに読みます。`claude plugin marketplace add` は同じチェックを実行し、予約名を `Failed to add marketplace:` で拒否し、その後に同じ予約名の文が続きます。

**対処方法：**

* マーケットプレイスが既に登録されている場合は、`claude plugin marketplace remove <name>` を実行してから、公式の `github.com/anthropics` リポジトリから再度追加してください
* 名前が予約される前に使用した第三者マーケットプレイスを公開する場合は、名前を変更し、ユーザーにソースから再度追加するよう依頼してください
* [マーケットプレイススキーマ](/docs/ja/plugins/marketplace-reference#marketplace-file)の下の予約名リストを参照してください

<h3 id="marketplace-name-is-another-spelling-of-a-reserved-name">
  マーケットプレイス名は予約名の別のスペルです
</h3>

マーケットプレイスの名前自体は予約名ではありませんが、Claude Code はそれを別のスペルとして扱います。[予約名](/docs/ja/plugins/marketplace-reference#reserved-name-spellings)は、どのスペルが予約名として数えられるかをリストします。Claude Code は、マーケットプレイスを追加するときにそのような名前を拒否します：

```text theme={null}
Failed to add marketplace: "claude.code.plugins" is another spelling of "claude-code-plugins", a reserved marketplace name.
```

マーケットプレイスが既にそのような名前で登録されている場合、そのエントリは読み込みを停止し、`/plugin`、`claude plugin install`、および `claude plugin update` は警告します：

```text wrap theme={null}
known_marketplaces.json has an entry named "claude.code.plugins", another spelling of the reserved marketplace name "claude-code-plugins", so it is ignored. Remove it with: claude plugin marketplace remove claude.code.plugins
```

名前がシェルクォートを必要とする場合、追加時の拒否は `This marketplace's name is another spelling of "<reserved>", a reserved marketplace name. It is not exactly the reserved name it appears to be.` と読みます。

**対処方法：**

* マーケットプレイスの名前を予約名のスペルではない名前に変更し、再度追加してください
* 無視されたエントリの警告については、提供される `claude plugin marketplace remove` コマンドを実行するか、`~/.claude/plugins/known_marketplaces.json` からエントリを削除してください

<h3 id="claude-code-refuses-the-marketplace-name">
  Claude Code がマーケットプレイス名を拒否します
</h3>

登録されたマーケットプレイスの名前は、[公式 Anthropic マーケットプレイスを偽装します](/docs/ja/plugins/marketplace-reference#reserved-names)。そのセクションがリストするルールの下で。

マーケットプレイスがチェックがそれをブロックする前にそのような名前で登録された場合、マーケットプレイスとそこからインストールされたプラグインは読み込みを停止します。Claude Code はマーケットプレイスのカタログを読むたびに名前をチェックするためです。名前が公式のものを模倣する場合、`claude plugin list` と `/plugin` **エラー**タブは、以下で始まるメッセージで影響を受けた各プラグインを報告します：

```text theme={null}
Claude Code refuses the marketplace name "anthropic-plugins-v2"
```

模倣する名前の場合、マーケットプレイス自体のエラーは `Claude Code refuses this marketplace's name: it looks like one of Anthropic's own` と読みます。`claude plugin marketplace add` は、`Marketplace name impersonates an official Anthropic/Claude marketplace` で任意の偽装名を拒否します。

v2.1.282 より前では、`claude plugin list` と `/plugin` は、マーケットプレイスの名前が原因として名前を付けずに、模倣する名前のプラグインを読み込みに失敗したものとして報告していました。

**対処方法：**

* `claude plugin marketplace remove <name>` を実行してください。これはマーケットプレイスからインストールされたプラグインもアンインストールし、保存されたデータを削除します
* マーケットプレイスを代わりに保持するには、メンテナーが名前を変更するまで待ってから、`claude plugin marketplace update <name>` を実行してください
* マーケットプレイスを公開する場合は、`marketplace.json` で名前を変更してください。ユーザーはマーケットプレイスを削除する代わりに更新します

<h3 id="marketplace-is-already-added-from-a-different-source">
  マーケットプレイスは既に別のソースから追加されています
</h3>

[`/plugin install <plugin> --marketplace <source>`](/docs/ja/plugins/install#add-a-marketplace-and-install-in-one-command)を通じてマーケットプレイスの追加を確認し、そのソースから Claude Code が取得したカタログは、既に別のソースから追加したマーケットプレイスと同じ名前で自分自身に名前を付けます。Claude Code は既存のマーケットプレイスを保持し、それを置き換えず、プラグインはインストールされません。

```text theme={null}
Marketplace "acme-tools" is already added from a different source (github:acme/plugins). To use this source instead, remove that marketplace first with /plugin marketplace remove acme-tools.
```

**対処方法：**

* 既に追加したマーケットプレイスが必要なものである場合は、名前でそこからインストールしてください：`/plugin install <plugin>@<name>`
* 新しいソースに切り替えるには、`/plugin marketplace remove <name>` を実行してから、インストールを再試行してください

<h3 id="plugin-command-references-user-config">
  プラグインコマンドがシェルコマンドで user\_config を参照しています
</h3>

プラグインフック、[monitor](/docs/ja/plugins/components#monitors)、または MCP [`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication)コマンドは、`${user_config.KEY}` [プラグインオプション](/docs/ja/plugins/manifest-reference#user-configuration)を参照し、置換された文字列はシェルに渡されます。`$(...)` を含む設定値、バックティック、または `;` はそこでコードとして実行されるため、Claude Code は値を置換する代わりにコンポーネントの開始を拒否します。チェックはコマンドテンプレートで実行されるため、値がまだ設定されていない場合でもエラーが表示されます。v2.1.207 より前では、値はシェルコマンドに置換されていました。

表現は、どの表面がオプションを参照したかによって異なります。シェル形式フックは以下を報告します：

```text theme={null}
Hook from plugin formatter@acme-tools references ${user_config.*} in a shell-form command. The substituted value would be re-parsed by the shell. Use exec form instead — {"command": "<executable>", "args": ["${user_config.KEY}", ...]} — or read $CLAUDE_PLUGIN_OPTION_<KEY> from the hook's environment. Command: ./scripts/notify.sh ${user_config.webhook_url}
```

モニターは以下を報告します：

```text theme={null}
Monitor "deploy-status" from plugin deploy-tools references ${user_config.*} in its command. The substituted value would be passed to a shell. Monitor commands cannot safely reference ${user_config.*}; have the monitor script read the value from a config file or prompt instead.
```

MCP `headersHelper` は以下を報告します：

```text theme={null}
headersHelper for MCP server 'internal-api' references ${user_config.*}. The substituted value would be passed to a shell; read the value inside the helper script instead (e.g. from an env var set in the server's "env" block).
```

**対処方法：**

* フックの場合、`args` 配列を追加して、[exec 形式](/docs/ja/hooks#exec-form-and-shell-form)で実行されるようにします。ここで、各 `${user_config.KEY}` は、その間にシェルがない 1 つの引数になります。または参照をドロップし、スクリプト内から `$CLAUDE_PLUGIN_OPTION_<KEY>` 環境変数を読み取ります
* モニターの場合、参照をドロップし、モニタースクリプトに設定ファイルから値を読み取らせます
* `headersHelper` の場合、`${user_config.KEY}` をサーバーの `headers` フィールドに移動します。これはシェル解析されません。または、ヘルパースクリプト内から値を読み取ります

<h3 id="plugin-archive-integrity-check-failed">
  プラグインアーカイブの整合性チェックが失敗しました
</h3>

プラグインのマーケットプレイスエントリは、`sha256` ピン付きの [`archive` ソース](/docs/ja/plugins/marketplace-reference#archive-plugin-source)を使用し、ダウンロードされたファイルのダイジェストはピンと一致しません。Claude Code はインストールを拒否するため、プラグインキャッシュに何も変わりません。不一致には 3 つの考えられる原因があります：

* 著者がピンを計算した後、URL のファイルが変更されました
* 著者がマーケットプレイスエントリに間違ったダイジェストを入力しました
* URL は著者がピンしたファイルとは異なるファイルを提供します

```text theme={null}
Plugin archive integrity check failed for https://artifacts.example.com/claude-plugins/my-plugin.zip: expected sha256 6bfa50e3d2e00c052b46abe51fff89346ac803e45771f76dcf6df1ab74cca5e1, got ac52220c0914ef8ca6a602e4a7362f88d30fb021110f72a6d15b68c3fe7df2b7. The archive was not installed. Verify the sha256 in the marketplace entry, or that the URL serves the intended file.
```

**対処方法：**

* プラグインを公開する場合は、URL が提供する正確なファイルのダイジェストを再計算します。例えば `shasum -a 256 my-plugin.zip` または PowerShell で `Get-FileHash -Algorithm SHA256 my-plugin.zip` を使用し、マーケットプレイスエントリの `sha256` を更新してください
* プラグインをインストールする場合は、`/plugin marketplace update <name>` を実行してカタログをリフレッシュします。エントリが修正された場合、インストールを再試行してください
* リフレッシュ後もダイジェストが一致しない場合は、インストール前にマーケットプレイス所有者にどのファイルをピンしたかを尋ねてください

<h3 id="path-escapes-plugin-directory">
  パスがプラグインディレクトリをエスケープします
</h3>

プラグインコンポーネントパスは、プラグインの `plugin.json` またはその[マーケットプレイスエントリ](/docs/ja/plugins/marketplace-reference#plugin-entries)で宣言され、プラグイン自体のディレクトリの外に解決されます。Claude Code はそのパスをドロップし、プラグインの残りを読み込みます。メッセージ内のコンポーネント名（`commands` や `hooks` など）は、パスを宣言したフィールドに名前を付けます。

```text theme={null}
commands path escapes plugin directory: ./../shared.md
```

`claude plugin` コマンド出力では、同じエラーは `Path escapes plugin directory: ./../shared.md (commands)` と読みます。

Claude Code は、`../shared-utils` のように書かれたプラグイン外を指すパスと、プラグイン外に導くシンボリックリンク（[マーケットプレイスシンボリックリンクルール](/docs/ja/plugins/host-marketplace#share-files-within-a-marketplace-with-symlinks)が許可するものではない）の両方を拒否します。シンボリックリンクの場合、メッセージはパスが解決される場所も示します：

```text theme={null}
commands path escapes plugin directory: ./commands/deploy.md — it resolves to /home/user/shared/deploy.md, outside the plugin directory
```

macOS と Linux では、Claude Code はコンポーネントパスにバックスラッシュが含まれているパスも拒否します。パスがプラグイン内に留まる場合でも。Windows スタイルのセパレータを使用するコンポーネントパスを持つプラグインは Windows で読み込まれ、他のプラットフォームでこの拒否をトリガーします：

```text theme={null}
commands path escapes plugin directory: ./commands\deploy.md — its path contains a backslash, which is not resolved reliably on this platform
```

v2.1.251 より前では、Claude Code はマーケットプレイスエントリで宣言された `commands` パスを、プラグインディレクトリの外を指していても読み込みました。

v2.1.257 より前では、チェックはパスのスペルのみを調べ、シンボリックリンクが導く場所を調べませんでした。

**対処方法：**

* 参照されたファイルをプラグインディレクトリ内に移動し、`./` 相対パスでそれを指してください
* パスがプラグイン外のファイルへのシンボリックリンクである場合は、シンボリックリンクをファイルのコピーに置き換えてください
* メッセージがパスにバックスラッシュが含まれていると言う場合は、パスを前方スラッシュで書いてください。例えば `./commands/deploy.md`
* 同じマーケットプレイス内の他のプラグインとファイルを共有するには、プラグインディレクトリ内のシンボリックリンクでそれらをリンクし、[シンボリックリンクルール](/docs/ja/plugins/host-marketplace#share-files-within-a-marketplace-with-symlinks)に従ってください

<h3 id="path-could-not-be-checked">
  パスをチェックできませんでした
</h3>

Claude Code はプラグインパスが存在するかどうかをオペレーティングシステムに尋ね、「見つかりません」以外のエラーを取得したため、パスが名前を付けるものを読み込みません。プラグインの読み込み量は、どのパスが失敗したかによって異なります：

* プラグインの[デフォルトコンポーネント位置](/docs/ja/plugins/manifest-reference#standard-layout)の 1 つ（`skills/` フォルダ、`monitors/monitors.json` ファイル、またはプラグインルートの [`SKILL.md`](/docs/ja/plugins/components#skills)）：プラグインの他のコンポーネントは引き続き読み込まれます
* プラグイン自体のディレクトリ：そのプラグインから何も読み込まれません

このエラーは、まったく存在しないパスに対しては表示されません。`/plugin` では、エラーはプラグインの下に表示され、パスとオペレーティングシステムが返したコードに名前を付けます：

```text theme={null}
skills path could not be checked: /home/user/my-plugin/skills (ELOOP)
```

`claude plugin list` では、同じエラーは `Path not found: /home/user/my-plugin/skills (skills, ELOOP)` と読みます。

このエラーを生成する原因には以下が含まれます：

* `ELOOP`：パス内のシンボリックリンクが自分自身を指すか、ループを形成します
* `EIO` または `ESTALE`：パスは壊れているか古いネットワークマウント上にあります
* `EACCES`：パスの上のディレクトリの 1 つがそれを横断する権限を拒否します

**対処方法：**

* 自分自身を指すシンボリックリンクを実フォルダに置き換えるか、削除してください
* パスがネットワークマウント上にある場合は、共有を再マウントしてください
* コードが `EACCES` の場合は、パスの上のディレクトリに対する実行権限を復元してください
* パスを修正した後、`/reload-plugins` を実行するか、Claude Code を再起動して、プラグインまたはコンポーネントを読み込んでください

v2.1.265 より前では、Claude Code はチェックできないデフォルトコンポーネントフォルダを存在しないものとして扱い、エラーなしでそのコンポーネントなしでプラグインを読み込みました。

<h3 id="marketplace-entry-path-does-not-stay-inside-the-marketplace-directory">
  マーケットプレイスエントリパスはマーケットプレイスディレクトリ内に留まりません
</h3>

プラグインの[マーケットプレイスエントリ](/docs/ja/plugins/marketplace-reference#plugin-entries)は、Claude Code がマーケットプレイス自体のディレクトリ内の位置に解決できないソースパスを宣言するため、プラグインはインストールまたは読み込まれません。拒否は以下をカバーします：

* 絶対的なエントリパス、`..` でマーケットプレイスから登ります、またはネットワークパスのようにスペルされています
* macOS と Linux では、先頭の `./` の後のどこかにバックスラッシュを含むエントリパス
* git または URL などのリモートソースから取得されたマーケットプレイス内のエントリ。マーケットプレイスディレクトリの外に解決するシンボリックリンクを通じてターゲットに到達します
* マーケットプレイスの `marketplace.json` への直接 URL から追加された相対エントリ：Claude Code はそのファイルのみをダウンロードするため、パスが名前を付けるローカルプラグインファイルは存在しません。[相対パスを持つプラグインが URL ベースのマーケットプレイスで失敗します](/docs/ja/plugins/troubleshooting#plugins-with-relative-paths-fail-in-url-based-marketplaces)を参照してください

`claude plugin install` は拒否を次のように報告します：

```text theme={null}
Cannot install my-plugin@my-marketplace: its marketplace entry path does not stay inside the marketplace directory (an absolute, climbing, network-shaped, backslash-containing or link-traversing entry, an entry of a fetched marketplace that resolves or opens outside its tree — or a relative entry in a url-catalog marketplace, which has no local directory)
```

既にインストールされているプラグインのエントリが同じチェックに失敗する場合、`claude plugin list` はプラグインを `failed to load` として表示します：

```text theme={null}
Plugin source path refused: ./my-plugin does not stay inside its marketplace directory. Check that the marketplace entry has a plain relative path.
```

**対処方法：**

* マーケットプレイスを維持する場合は、エントリの `source` を `./plugins/my-plugin` などの単純な相対パスとして書き、それが横断するシンボリックリンクをマーケットプレイスディレクトリ内を指すようにしてください
* マーケットプレイスを直接 URL から追加した場合、相対エントリは解決できません。マーケットプレイス作成者に[別のプラグインソース](/docs/ja/plugins/marketplace-reference#plugin-sources)を使用するよう依頼するか、代わりに git リポジトリからマーケットプレイスを追加してください

<h3 id="failed-to-load-marketplace-configuration">
  マーケットプレイス設定の読み込みに失敗しました
</h3>

Claude Code は、`~/.claude/plugins/known_marketplaces.json` のレジストリファイルに追加したプラグインマーケットプレイスを保持します。`claude plugin install` などのレジストリが必要なプラグインコマンドは、Claude Code がファイルを使用できない場合、2 つのメッセージのいずれかで失敗します：

* `Failed to load marketplace configuration`：ファイルは存在しますが、有効な JSON ではないか、読み取ることができません。空のファイルもこの方法で失敗します。
* `Marketplace configuration file is corrupted`：ファイルは有効な JSON ですが、その内容はレジストリスキーマと一致しません。

空のファイルの場合、`claude plugin install` は以下を報告します：

```text theme={null}
✘ Failed to install plugin "my-plugin": Failed to load marketplace configuration: JSON Parse error: Unexpected EOF
```

v2.1.246 より前では、`claude plugin install` はこの失敗を報告しませんでした。

**対処方法：**

* `~/.claude/plugins/known_marketplaces.json` を開き、JSON を修復するか、メッセージが名前を付けるエントリをレジストリスキーマと一致するように修正してください
* 修復できない場合は、ファイルを削除するか、その内容を `{}` に置き換えてから、`claude plugin marketplace add <source>` で各マーケットプレイスを再度追加してください。Claude Code は、信頼したフォルダで次回起動するときに、ユーザーまたは管理設定が [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) で宣言するマーケットプレイスを再登録します。

<h3 id="plugin-is-required-by-your-organization">
  プラグインは組織で必須です
</h3>

`claude plugin disable` を実行するか、`/plugin` **インストール済み**タブを使用して、組織が必須としてマークする [claude.ai から同期されたプラグイン](/docs/ja/plugins/loading#synced-plugins)をオフにしました：

```text theme={null}
Plugin "<name>@synced" is required by your organization and can't be disabled here. Contact your admin to change it.
```

Claude Code は何も保存せず、プラグインは有効なままです。

必須プラグインが依存するプラグインを無効にしようとすると、Claude Code は同じ方法で拒否し、それを必要とする必須プラグインに名前を付けるメッセージを表示します。

**対処方法：**

* claude.ai 組織の管理者に、プラグインの必須ステータスを claude.ai で変更するよう依頼してください

<h3 id="plugin-was-not-uninstalled">
  プラグインはアンインストールされませんでした
</h3>

[`claude plugin uninstall`](/docs/ja/plugins/cli-reference#plugin-uninstall)を実行するか、`/plugin` **インストール済み**タブで **アンインストール**を選択し、アンインストールは `"<plugin>" was not uninstalled:` で始まるメッセージで停止しました。そのコロンの後のテキストが設定ファイルの名前ではなく `installed_plugins.json` で始まる場合、原因は `installed_plugins.json` 内のこのバージョンの Claude Code が読み取ることができないコンテンツです。その形式については、[`installed_plugins.json` はこのバージョンが読み取ることができないレコードを保持しています](/docs/ja/plugins/troubleshooting#installed-plugins-json-holds-a-record-this-version-cannot-read)を参照してください。

Claude Code がプラグインのエントリを `enabledPlugins` から削除し、そのスコープの設定ファイルを読み直したとき、プラグインはそこでまだオンに切り替えられたか、それをオンに切り替えることができるファイルを読み取ったり確認したりできませんでした。プラグインの保存されたオプション、シークレット、およびデータを削除しながら、設定エントリがそれをオンに切り替えることができるのは、それらを失うことになるため、アンインストールは代わりに停止します：プラグインはインストールされたままで、保存されたものは削除されません。

```text theme={null}
✘ Failed to uninstall plugin "formatter": "formatter" was not uninstalled: it is still switched on in /home/user/project/.claude/settings.local.json, although the settings change reported no error. It is still installed. Take it out of "enabledPlugins" in that file yourself, then uninstall it again.
```

メッセージの中央はファイルと原因に名前を付けます：

* `it is still switched on in <file>, although the settings change reported no error`：設定の書き込みは成功を報告しましたが、エントリはファイルを読み直すときにまだそこにあります
* `it is still switched on in <file>, and the settings change failed (<error>)`：ファイルを保存できませんでした。括弧内の理由のため
* `<file> is there and could not be read`：ファイルは存在しますが、設定として読み取ることができませんでした。例えば、有効な JSON ではないため、プラグインを有効にしたままの可能性があります
* `<file> (not read: it is on a network path or is a link to one, or could not be checked)`：Claude Code はプロジェクトまたはローカル設定ファイルを読み取りませんでした。ファイル、またはそれを保持する `.claude` フォルダは、ネットワークの場所にリンクしているか、そのパスを調べることができなかったためです

`claude plugin uninstall` は終了コード 1 で、`--json` を使用すると結果は `failureCode: "settings_still_on"` を含みます。`/plugin` は同じメッセージを表示します。

**対処方法：**

* メッセージの最後の文に従ってください：それが名前を付ける設定ファイルを修復または置き換えるか、そのファイルの `enabledPlugins` からプラグインのエントリを自分で削除してから、アンインストールを再度実行してください

<h2 id="tool-errors">
  ツールエラー
</h2>

これらのエラーは Claude のツール呼び出しから発生します。Claude はほとんどのツールエラーを自動的に修正します。変更が必要な場合、そのエラーの **What to do** リストに何を変更するかが記載されています。

<h3 id="no-such-tool-available">
  No such tool available
</h3>

Claude が、セッションのツールリストにない名前でツールを呼び出しました。Claude Code はそのエラーをツール呼び出しの結果として Claude に返し、ターンは続行します。ツールが存在しない理由を Claude Code が判断できる場合は、2 行目のように、ツール名の後に理由や代わりに呼び出すべきツールを示す文を追加します。

```text theme={null}
Error: No such tool available: <tool name>
Error: No such tool available: read. Tool names are case-sensitive: call Read instead.
```

セッションを再開した直後は、Claude が MCP サーバーのツールを呼び出した時点で、そのサーバーがまだ最初の接続試行中である場合があります。その場合、Claude Code は [サーバーを待機](/docs/ja/mcp#tool-availability) し、待機が終了してもツールが利用できない場合にこのエラーを返します。v2.1.284 より前は、このような呼び出しは待機せずにすぐに失敗していました。

Claude Code が [200 文字に切り詰めた](#tool-use-name-over-200-characters) ツール名での呼び出しも、このエラーで失敗します。

**What to do:**

* 1 回だけ発生した場合は、何もする必要はありません。Claude がエラーを読み取り、ターンは続行します。
* MCP サーバーのツールへの呼び出しがこのエラーで失敗し続ける場合は、セッション内で `/mcp` を実行するか、シェルで `claude mcp list` を実行してサーバーの [ステータス](/docs/ja/mcp#server-status) を確認し、失敗したサーバーを `/mcp` から再接続します。Agent SDK では、[エラー処理](/docs/ja/agent-sdk/mcp#error-handling) を参照してください。

<h3 id="agent-would-be-spawned-with-zero-tools">
  Agent would be spawned with zero tools
</h3>

サブエージェントの [`tools` リスト](/docs/ja/sub-agents#supported-frontmatter-fields) のすべてのエントリが使用可能なツールと一致しなかったため、Claude Code はサブエージェントの起動を拒否しました。ツールがないと、サブエージェントは動作できません。メッセージはエントリを何が問題かでグループ化します。

* **Unrecognized**: エントリがツール名と一致しません。通常は `Grpe` のような `Grep` のタイプミスです。
* **Not available to subagents**: エントリが [サブエージェントが使用できない](/docs/ja/sub-agents#available-tools) 実際のツールを指定しています。バックグラウンドサブエージェントはより小さい組み込みツールセットを保持しているため、フォアグラウンドサブエージェントのみが使用できるエントリは、サブエージェントがバックグラウンドで実行される場合（これがデフォルトです）、ここに表示されます。`Agent` をリストする場合、メッセージは代わりに次のグループの下に報告します。
* **Matched no tools in this session**: エントリは有効ですが、現在のセッションのツールが今すぐそれと一致しません。例えば、GitHub MCP サーバーが接続されていない `mcp__github__*` や、[深さ制限](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents) にあるサブエージェントの `Agent` などです。

`tools` フィールドを省略することは、この拒否をトリガーしません。`tools` リストを空のままにするか、`disallowedTools` がそれ内のすべてのエントリを削除する場合、Claude Code も拒否をスキップし、ツールなしでサブエージェントを起動します。

v2.1.208 より前は、サブエージェントはツールなしで起動し、空または混乱した結果を返す可能性がありました。

```text theme={null}
Agent 'code-reviewer' would be spawned with zero tools — refusing. Its tools list resolved to nothing: unrecognized [Grpe]. Fix the agent's tools frontmatter or pass a different subagent_type.
```

**What to do:**

* エラーが指定する各エントリを [サブエージェントが利用可能なツール](/docs/ja/sub-agents#available-tools) に対して修正します
* セッションが持たないツールのエントリを削除します。例えば、接続されていないサーバーからの MCP ツール
* [バックグラウンドサブエージェントが削除する](/docs/ja/sub-agents#available-tools) ツール（例えば `CronCreate`）の場合、エントリを削除します。ツールを保持するには、[フォークモードをオフにして](/docs/ja/sub-agents#turn-fork-mode-on-or-off) Claude にサブエージェントをフォアグラウンドで実行するよう依頼します
* `tools` フィールドを削除して、サブエージェントに [サブエージェントが利用可能なすべてのツール](/docs/ja/sub-agents#available-tools) を与えます
* `Agent` のみを含む `tools` リストの場合、[深さ制限](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents) を上げるか、エージェントに少なくとも 1 つの他のツールを与えます。Claude Code はその制限で `Agent` を保留するため、リストに他に何もない場合、ツールに解決されません

<h3 id="file-is-covered-by-a-read-deny-rule">
  File is covered by a Read deny rule
</h3>

Edit または Write ツールが [`Read` 拒否ルール](/docs/ja/permissions#read-and-edit) と一致するパスで呼び出されました。これには、そのパスで新しいファイルを作成することも含まれます。両方のツールは Claude が読み戻す必要があるコンテンツを変更するため、Claude Code はファイルアクセスの前に呼び出しを拒否します。NotebookEdit は `Read` 拒否ルールの対象ではありません。v2.1.228 より前は、ルールは Edit ツールのみをブロックし、v2.1.208 より前は、`Edit` 拒否ルールのみが編集をブロックしました。

```text theme={null}
File is covered by a Read deny rule in your permission settings and cannot be edited.
```

Claude Code が Write ツールを拒否する場合、メッセージは代わりに `and cannot be written` で終わります。

**What to do:**

* Claude がファイルを変更できるべき場合、`/permissions` または [設定](/docs/ja/settings-reference#permission-settings) の `Read` 拒否ルールを削除または縮小します
* ファイルが変更されないままである必要がある場合、ルールを保持し、NotebookEdit ツールもブロックするために同じパスの `Edit` 拒否ルールを追加します

<h3 id="path-cannot-contain-null-bytes">
  Path cannot contain null bytes
</h3>

ファイルツール呼び出しのパスまたはパターン引数に null バイトが含まれていました。ファイルシステムと検索ツールはこれを受け入れることができません。Read、Write、Edit、NotebookEdit、Glob、Grep はこれをチェックし、メッセージはツールと引数を指定します。

```text theme={null}
Read file_path cannot contain null bytes (\0). Remove the null byte and try again.
```

ツール呼び出しは失敗し、Claude はエラーを見て、ターンは続きます。

**What to do:**

* ユーザー側で行う必要のある操作はありません。エラーはツールの結果として Claude に返され、メッセージ自体が Claude に null バイトを削除して再度試すよう指示します

v2.1.281 より前は、Read、Write、Edit、または NotebookEdit パスの null バイトがターン全体を `Path contains null bytes` という名前のエラーで終了し、ツールは実行されませんでした。

<h3 id="subagent-type-is-required">
  subagent\_type is required
</h3>

```text theme={null}
subagent_type is required: the general-purpose agent is not available in this session. Available agents: ...
```

Claude は `subagent_type` なしで [Agent ツール](/docs/ja/tools-reference#agent-tool-behavior) を呼び出し、このセッションにはフォールバックする [汎用サブエージェント](/docs/ja/sub-agents#built-in-subagents) がありません。これは 2 つのセットアップの場合です。

* [`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](/docs/ja/env-vars) は非対話モードで設定されており、すべての組み込みサブエージェントを削除します
* セッションのメインスレッドエージェントには [`tools: Agent(...)` 許可リスト](/docs/ja/sub-agents#restrict-which-subagents-can-be-spawned) があり、`general-purpose` を除外しています

**What to do:**

* 通常は何もしません。メッセージはセッションが持つサブエージェントをリストするため、Claude はそのうちの 1 つで再試行できます
* Claude が失敗し続ける場合、`tools: Agent(...)` 許可リストに `general-purpose` を追加するか、`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` を設定解除します

v2.1.235 より前は、同じ呼び出しが `Agent type 'general-purpose' not found` で失敗しました。

<h3 id="memory-index-is-over-its-read-limit">
  Memory index is over its read limit
</h3>

Claude は [自動メモリ](/docs/ja/memory#auto-memory) インデックス `MEMORY.md` に書き込み、その読み取り制限の 1 つを超えたままにしました。200 行または 25KB です。書き込みは成功しましたが、最初の 200 行または 25KB のみ（どちらか先に来た方）がセッションの開始時に読み込まれるため、制限を超えるすべてのものはインデックスが読み込まれるたびに削除されます。v2.1.210 より前は、制限を超えたインデックスは書き込み時の信号なしで次の読み込み時に静かに切り詰められました。

```text theme={null}
Error: this write left the memory index at MEMORY.md at 214 lines, over its 200-line read limit. The write succeeded, but everything past the limit is silently dropped each time the index is loaded — entries at the end are already invisible to readers. Rewrite it to under 140 lines now: keep one line per entry, move detail into topic files, and merge or drop stale entries.
```

読み込まれるコンテンツのみが制限にカウントされます。YAML フロントマターとブロックレベルの HTML コメントはインデックスが読み込まれる前に削除されるため、測定から除外されます。v2.1.211 より前は、Claude Code は生ファイルを測定し、フロントマターまたはコメントは読み込まれたコンテンツが適合しても、このエラーをトリガーする可能性がありました。

Claude Code はエラーを書き込み後に Claude に配信するため、ターミナルにバナーとして出力されず、トランスクリプトでのみ気付く可能性があります。

Claude の書き込みがファイルを制限に近づけても超えない場合、Claude Code はこのエラーの代わりにインデックスをコンパクトにするための穏やかなリマインダーを返します。

**What to do:**

* Claude に `MEMORY.md` を書き直させるか、依頼します。エントリごとに 1 行を保持し、詳細をトピックファイルに移動し、古いエントリをマージまたは削除します
* インデックスを自分でトリミングするには、[メモリの監査と編集](/docs/ja/memory#audit-and-edit-your-memory) を参照してください

<h3 id="pkill-pattern-matches-the-claude-code-process">
  pkill pattern matches the Claude Code process
</h3>

Bash ツール呼び出しの `pkill` コマンドは、通常 `-f` を使用して、Claude Code プロセス自体と一致するパターンを使用したため、Claude Code はコマンドを実行してセッションを終了させるのではなく、コマンドを拒否します。Claude Code は `pkill` を実行する前に `pgrep` でパターンをテストし、独自のプロセス ID が結果に含まれている場合は拒否します。チェックは Linux でのみ実行されます。macOS では、`pkill` は変更されずに実行されます。v2.1.214 より前は、コマンドが実行され、一致するパターンが Claude Code セッションをターン中に終了しました。

```text theme={null}
pkill: refusing to run — this pattern matches the Claude CLI process (PID 12345). Narrow the pattern, or target your own children with `pkill -P $$ ...`.
```

拒否はターミナルのバナーではなく、Bash ツール結果に表示され、Claude は通常、コマンドを自動的に調整します。

**What to do:**

* パターンを絞り込んで、意図したプロセスのみと一致するようにします。例えば、短い部分文字列ではなく、ターゲットバイナリの完全なパスです
* 現在のシェルで開始されたプロセスを停止するには、パターンで `pkill -P $$` を使用します。これにより、マッチをシェルの独自の子プロセスに制限します

<h3 id="failed-to-write-to-a-teammate-inbox">
  Failed to write to a teammate's inbox
</h3>

Claude Code は `~/.claude/teams/{team-name}/inboxes/` の下のチームメイトのメールボックスファイルにメッセージを書き込むことができなかったため、受信者は何も受け取りませんでした。書き込みは、Claude Code がファイルを作成または更新できない場合に失敗します。例えば、ディスクがいっぱいである、ディレクトリが書き込み可能でない、または別のエージェントがインボックスロックを長時間保持している場合です。v2.1.224 より前は、Claude Code は書き込みが失敗した場合でも、メッセージが送信されたと報告していました。

エラーはターミナルのバナーではなく、送信エージェントのツール結果に表示され、テキストは Claude に再度試すよう指示します。

```text theme={null}
Failed to write to researcher's inbox — nothing was sent. Try again, or message the lead.
```

構造化された [エージェントチーム](/docs/ja/agent-teams) プロトコルメッセージは同じ方法で失敗し、エラーは配信されなかったメッセージを指定します。Claude Code が計画承認、計画却下、シャットダウン要求、またはシャットダウン却下を書き込むことができない場合、エラーは `Failed to write the <message> to <name>'s inbox — nothing was sent` と読みます。そのリストの `plan approval` はチームリーダーの決定であり、チームメイトの計画を承認します。チームメイトの計画提出は別の `plan approval request` メッセージです。そのメッセージと他の 2 つのプロトコルメッセージは、独自のメッセージテキストと結果を持ちます。

* `Failed to write the plan approval request to the lead's inbox — plan not submitted; try again`: チームメイトの計画がチームリーダーに到達せず、チームメイトは再提出が成功するまで plan モードのままです
* `The permission request could not be delivered to the team lead (mailbox write failed)`: チームメイトの権限要求がチームリーダーに到達しなかったため、誰もツール呼び出しを承認しませんでした
* `The confirmation could not be written to team-lead's inbox.`: シャットダウン承認自体が有効になり、チームメイトは終了します。チームリーダーへの確認のみが不足しています

チームリーダーのセッションで `@name` に続けてメッセージを入力し、自分でチームメイトにメッセージを送信する場合、同じ失敗は通知 `Couldn't write to @name's inbox — message not sent. Try again.` として表示され、Claude Code はテキストをプロンプトボックスに保持して、再度送信できるようにします。

**What to do:**

* 送信者にメッセージを再送信するよう依頼します。インボックスロックの競合は一時的であり、再試行時にクリアされます
* 空きディスク容量を確認し、`~/.claude/teams` とその下のファイルがユーザーによって書き込み可能であることを確認します

<h3 id="teammate-agent-definition-not-restored">
  Teammate's agent definition was not restored
</h3>

Claude が停止した [エージェントチーム](/docs/ja/agent-teams) のチームメイトにメッセージを送信し、Claude Code はそのチームメイトを復帰させましたが、生成元の [サブエージェント定義](/docs/ja/agent-teams#use-subagent-definitions-for-teammates) を再適用しませんでした。通知は、送信エージェントのツール結果の再開レポートに続いて表示され、理由を示します。定義ファイルが信頼の保存されていないフォルダから来た場合、通知は次のようになります。

```text wrap theme={null}
Its agent definition was not restored: the folder its definition file came from is not trusted (source: projectSettings), so the teammate is running with the team-essential tools and no custom instructions. To restore it, the user needs to run Claude Code in that folder once and accept the trust dialog (the --debug log names the folder); do not change trust settings on the user's behalf.
```

チェックは、プロジェクトまたは `--add-dir` ディレクトリの `.claude/agents/` ディレクトリ内の定義に適用され、親フォルダの信頼ダイアログを受け入れることはそれを満たしません。

**What to do:**

* [デバッグログ](/docs/ja/debug-your-config) が指定するフォルダで `claude` を実行し、信頼ダイアログを受け入れます。定義は Claude Code がチームメイトを次に復帰させるときに再適用されます。チームリーダーのセッションを再起動する必要はありません
* または、`~/.claude.json` の `hasTrustDialogAccepted` エントリを `true` に設定します。デバッグログが出力する正確な `projects["<path>"]` キーを使用します

<h3 id="message-too-large-for-cross-session-delivery">
  Message too large for cross-session delivery
</h3>

Claude の [クロスセッションメッセージ](/docs/ja/cross-session-messaging) は、このマシン上の別のセッションに対して長すぎて送信できませんでした。Claude Code はそれを拒否し、受信セッションは何も受け取りませんでした。拒否はターミナルのバナーではなく、送信セッションのツール結果に表示されます。両方のサイズとメッセージを適合させる方法を指定します。

```text wrap theme={null}
Failed to send to api-worker: Message too large for cross-session delivery: the serialized message is 1,203,844 characters and the limit is 1,048,576. Shorten the message text — put bulk content in a file the recipient can read rather than in the message — or split it into smaller messages.
```

同じテキストを再送信すると、同じ方法で失敗します。

**What to do:**

* Claude にメッセージを要約するか、バルクコンテンツをファイルに入れてそのファイルのパスを送信するよう依頼します
* Claude にコンテンツを複数の短いメッセージに分割するよう依頼します

v2.1.235 より前は、Claude Code は超過サイズのメッセージが送信されたと報告していました。受信セッションはそれを未読で削除しました。

<h3 id="too-many-messages-to-this-session-just-now">
  Too many messages to this session just now
</h3>

Claude は [クロスセッションメッセージ](/docs/ja/cross-session-messaging) の急速なバーストをこのマシン上の 1 つのセッションに送信し、バーストはそのセッションのインボックスが受け入れるものに達しました。Claude Code は次の送信を拒否し、受信セッションはそれから何も受け取りませんでした。拒否はターミナルのバナーではなく、送信セッションのツール結果に表示されます。

```text wrap theme={null}
Failed to send to api-worker: Too many messages to this session just now: 30 were sent recently and more would be dropped by its rate limit, so this one was not sent. Batch what remains into one message, or wait a little before sending more.
```

**What to do:**

* 通常は何もしません。Claude は残りのコンテンツを 1 つのメッセージにバッチ処理するか、さらに送信する前に少し待ちます
* バースト自体をプロンプトした場合、Claude に残りのものを 1 つのメッセージに結合するよう依頼します

v2.1.236 より前は、Claude Code はこれらの送信が送信されたと報告していました。受信セッションはそれらを未読で削除しました。

<h3 id="cross-session-message-dropped-at-the-inbox">
  Cross-session message was dropped at the recipient session's inbox
</h3>

Claude は [クロスセッションメッセージ](/docs/ja/cross-session-messaging) をこのマシン上の別のセッションに送信し、そのセッションのインボックスは Claude がそのセッションで読む前にそれを破棄しました。行は受信者のアドレスを指定し、受信者が理由を与えた場合、ダッシュの後に理由を追加します。

```text wrap theme={null}
Cross-session message was dropped at the recipient session's inbox (recipient: uds:/tmp/cc-socks/13605.sock) and not delivered — its queue of undelivered peer messages was full. Claude was told not to resend right away.
```

1 行は複数の削除されたメッセージをカバーできます。その場合、行は複数形で始まります。例えば `Cross-session messages (12) were dropped`。アドレスがどのセッションに属しているかを見つけるには、各セッションで `/status` が表示する [`Peer address` 行](/docs/ja/cross-session-messaging#the-sessions-inbox-socket) と比較します。

ダッシュの後、行は以下の 1 つ以上の理由を与えます。

* `its queue of undelivered peer messages was full`: 受信者は既に他のセッションから配信されていないメッセージを多く保持しており、そのキューが許可する限りです
* `you sent faster than that session accepts`: 送信セッションのメッセージは受信者が 1 つの送信者から受け入れるより速く到着しました
* `it repeated your previous message`: メッセージは送信セッションが最近この受信者に送信したものと同じでした
* `a relay loop between sessions was cut`: メッセージはセッションが互いにメッセージを送信するチェーンを続け、チェーンは受信者を何度も通過したか、成長しすぎました

**What to do:**

* 削除されたメッセージを受信者が見たことがないと仮定します。Claude Code は同じことを Claude に伝え、それでも重要なものを 1 つの後のメッセージに含めるよう指示し、すぐに再送信しないよう指示します
* セッションが互いに頻繁に更新を送信する場合、Claude にセッションが作業を完了したときなど、より少なく、より大きなメッセージを送信するよう依頼します
* `a relay loop between sessions was cut` の場合、セッションの 1 つに自分で次の指示を入力します。Claude が自分のプロンプトに応答して送信するメッセージは新しいチェーンを開始します

v2.1.238 より前は、受信者のインボックスがメッセージを破棄したときに送信セッションはレポートを受け取りませんでした。

<h3 id="refusing-to-send-a-cross-session-message">
  Refusing to send a cross-session message
</h3>

Claude Code が [クロスセッションメッセージ](/docs/ja/cross-session-messaging) をこのマシン上の別のセッションに書き込む前に、ターゲットセッションのインボックスソケットがメッセージが宛てられたエンドポイントであることを確認します。チェックが失敗すると、Claude Code は送信セッションで送信を拒否し、ターゲットセッションは何も受け取りません。Claude が送信するメッセージの場合、拒否は送信セッションのツール結果に表示されます。

```text theme={null}
Failed to send to api-worker: Refusing to send: reply target is a symlink
```

`Refusing to send:` の後のテキストは、失敗したチェックを指定します。

* `reply target is a symlink`: シンボリックリンクがターゲットセッションのソケットパスにあります。Claude Code はそれを通じて配信しません。リンクがそこにあると、メッセージをターゲットセッションが作成しなかったエンドポイントにリダイレクトする可能性があるためです。
* `cannot vet reply target`: Claude Code はターゲットパスをまったく検査できませんでした。例えば、権限エラーで読み取りが失敗したためです。

**What to do:**

* 通常は何もしません。チェックはメッセージが宛てられたセッション以外のエンドポイントに到達するのを防ぎ、何も送信されませんでした
* `reply target is a symlink` がセッションで繰り返される場合、そのセッションのソケットパスにリンクを作成したものを確認します。これは `/status` の `Peer address` に表示されます

<h3 id="refusing-after-a-symlink-changed">
  Refusing to read, write, or search a path
</h3>

Claude Code はファイルパスの [権限ルール](/docs/ja/permissions#read-and-edit) をチェックし、ツールがファイルを開くか検索を開始するときに解決を再度確認します。パスがチェックが承認した場所にまだ導いていることを確認できない場合、Claude Code はパスをたどらずに操作を拒否します。拒否はツール結果に表示されます。

```text wrap theme={null}
Refusing to read /path/to/file: its symlink resolution changed after permission was checked (a link on the way now leads somewhere the check did not see). If a link in the working directory is being rewritten concurrently, stop that and retry.
```

各拒否はその理由を指定します。

* `its symlink resolution changed after permission was checked`: パスに沿ったシンボリックリンク、または Grep または Glob 検索ルートが、権限チェックと操作の間に置き換えられました。読み取り拒否では、括弧内のフレーズはどの比較が失敗したかを指定します。
* `its parent-directory symlink resolution changed after permission was checked`: 書き込みパスが通過するディレクトリは、承認された場所に解決されなくなりました
* `where it leads on disk could not be determined (a link on the way could not be examined, or the links do not resolve)`: Claude Code はパスをディスク上の最終的な場所まで追跡できませんでした。例えば、パス上のシンボリックリンクがループを形成しているためです
* `it is a symbolic link. Write to the link's target path instead`: シンボリックリンクが要求された書き込み場所自体にあります。例えば、`CLAUDE.md` が `AGENTS.md` へのシンボリックリンクです。メッセージは Claude をリンクのターゲットに指示します
* `Refusing to write through symlink: <path>. Resolve the symlink and pass the real target path explicitly.`: 別のライターがファイルを開くときに捕捉された同じ条件。例えば、シンボリックリンクされた `.mcp.json` への書き込み
* `Refusing to write into symlinked directory: <path>`: ファイルを保持するディレクトリ自体がシンボリックリンクです。例えば、プロジェクトの `.claude/` ディレクトリが別の場所にリンクされています
* `a path one of its Read deny rules is written through changed while the search was being prepared. Retry.`: 検索の `Read` 拒否ルールはシンボリックリンクを通過するパスを指定し、そのリンクは Claude Code が検索を準備している間に変更されました
* `it could not be opened (EACCES) — it is unreadable, or is being replaced concurrently.`: 検索ルートは存在しますが、開くことができませんでした。括弧内のコードはオペレーティングシステムエラーです
* `its permission check expired before it ran (too many concurrent file operations). Retry.`: Claude Code は多くの同時ファイル操作の下で、ツールが使用する前に承認レコードを削除しました。再試行は新しい権限チェックを実行します
* `ripgrep was found only by name on PATH, and a search outside the working directory cannot apply your Read deny rules in that configuration`: Claude Code は `rg` バイナリを絶対パスに解決できなかったため、拒否ルールをカバーしない検索を実行するのではなく、作業ディレクトリの外の検索を拒否します

**What to do:**

* 通常は何もしません。拒否は Claude にツール結果として到達し、拒否された操作は実行されません
* シンボリックリンク拒否が 1 つのパスで繰り返される場合、ビルドツールやファイルウォッチャーなど、リンクをそこで書き直し続けるものを見つけるか、Claude にファイルのリンクされたパスではなく解決されたパスを使用するよう依頼します
* Windows 上の AppContainer または制限されたトークンサンドボックス内で Claude Code を実行しているときに、すべてのファイルでこの拒否が表示される場合、v2.1.265 以降にアップグレードします
* プロンプトにドラッグしたスクリーンショットなど、何も書き直していないファイルに対して macOS で読み取り拒否が表示される場合、v2.1.273 以降にアップグレードします
* ripgrep 拒否の場合、パッケージマネージャーで ripgrep をインストールして、`rg` が `PATH` 上の絶対パスに解決されるようにするか、作業ディレクトリの下で検索を保持します

v2.1.251 より前は、Claude Code はファイル書き込みに対してのみパスの解決を再チェックしたため、権限チェック後に置き換えられたリンクは、メッセージなしで読み取りまたは検索を別の場所にリダイレクトする可能性がありました。これらのうち、親ディレクトリ、シンボリックリンク経由、およびシンボリックリンクされたディレクトリ書き込み拒否のみが以前のバージョンに表示されます。

v2.1.280 より前は、`where it leads on disk could not be determined` 拒否は表示されませんでした。

<h3 id="task-output-swap-refused">
  Task output swap refused
</h3>

Claude Code は各 Bash コマンドの出力を一時ディレクトリの下のファイルに保存します。これらのファイルの 1 つを開くたびに、シンボリックリンク、追加のハードリンク、または移動されたディレクトリによってリダイレクトされることなく、パスがまだ作成したファイルに導いていることを確認します。このメッセージは、そのチェックが失敗したことを意味するため、Claude Code はそのパスを通じて出力を書き込みまたは読み取るのではなく、操作を拒否しました。メッセージは Bash ツール結果に表示されます。

```text wrap theme={null}
task output swap refused (tasks dir moved or linked): /private/tmp/claude-501/-Users-you-my-project/1f0e62dc-4b0a-4f5e-9c2d-8a7b6c5d4e3f/tasks/b7k2f9m3q.output. To recover: restart Claude Code with CLAUDE_CODE_TMPDIR set to a fresh directory; or, if /private/tmp/claude-501/-Users-you-my-project is a stray directory or a symbolic link that should not be there, remove that entry itself (not what it points to) and restart.
```

括弧内のテキストは失敗したチェックを指定します。`output symlink was re-pointed`、`output file identity changed`、`not a regular file` などの理由はすべて同じ条件を報告します。出力パスにある、またはパスに沿ったものが、Claude Code が作成したファイルではなくなっています。一部の理由のみが `To recover:` 文を持ちます。

コマンドがまだ実行中にチェックが失敗する場合、Claude Code はコマンドを停止し、その結果は以下を報告します。

```text theme={null}
Command killed: its output file was replaced or could no longer be verified
```

**What to do:**

* v2.1.260 以降にアップグレードします。以前のバージョンは、リンクまたは移動されたディレクトリが存在しない場合でも、このメッセージを表示することがありました
* [`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) を新しいディレクトリに設定して Claude Code を再起動します
* または、Claude Code の一時ディレクトリの下にあるプロジェクトのディレクトリ（例のメッセージでは `/private/tmp/claude-501/-Users-you-my-project`）を確認します。そのパスがシンボリックリンクである場合、またはそこにあるべきではないディレクトリである場合、リンクのターゲットではなく、リンクまたはディレクトリ自体を削除して、Claude Code を再起動します
* 拒否が繰り返される場合、プロセスはセッションの実行中に Claude Code の一時ディレクトリの下のエントリを置き換え、リンク、または削除しています。[`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) を他に何も管理しないディレクトリに設定して再起動します

<h3 id="disk-quota-or-temp-filesystem-is-full">
  Disk quota or temp filesystem is full
</h3>

Claude Code は各 Bash および PowerShell コマンドの出力を一時ディレクトリの下のファイルに保存します。コマンドがゼロ以外のコードで終了し、出力がまったくない場合、Claude Code はそのファイルを保持するファイルシステムが容量不足またはアイノード不足であるか、またはそれに対するディスク割り当てが使い果たされているかをチェックします。そうである場合、診断はコマンドの結果に空の出力の代わりに表示されます。

```text wrap theme={null}
Your disk quota is full on the filesystem with Claude Code's temp directory /private/tmp/claude-501/-Users-you-my-project/1f0e62dc-4b0a-4f5e-9c2d-8a7b6c5d4e3f/tasks (EDQUOT), so any output this command printed was lost, and it may have failed because it could not write. Delete files you no longer need there, or restart Claude Code with CLAUDE_CODE_TMPDIR set to a directory on another filesystem.
```

メッセージは何が不足しているかを指定します。

* `Your disk quota is full ... (EDQUOT)`: そのファイルシステムに対するユーザー自身の割り当てが使い果たされています。割り当ては、ファイルシステムがまだ空き容量を表示している間に満杯になる可能性があります
* `The filesystem with Claude Code's temp directory ..., or your disk quota on it, is full (ENOSPC)`: ファイルシステム、またはそれに対するユーザーの割り当てに、容量が残っていません
* `Command output was lost: the temp filesystem at ... is full` または `... is out of inodes`: ファイルシステムにはほぼ空き容量がないか、アイノードが不足しています

**What to do:**

* Claude Code の一時ディレクトリを保持するファイルシステム上で不要になったファイルを削除します。`EDQUOT` の場合、自分の割り当てにカウントされるファイルを削除します。`out of inodes` の場合、少数の大きなファイルではなく、多くのファイルを削除します。各ファイルはサイズに関係なく 1 つのアイノードを取ります
* または、[`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars) を容量のあるファイルシステム上のディレクトリに設定して Claude Code を再起動します
* その後、Claude にコマンドを再度実行させます。コマンドが出力した内容は、切り詰められたのではなく失われています

<h3 id="the-source-file-is-not-valid-utf-8-text">
  The source file is not valid UTF-8 text
</h3>

Claude は、バイトがテキストとしてデコードされないか、テキストが既に置換文字 `U+FFFD` を含むファイルから [アーティファクト](/docs/ja/artifacts) を公開しようとしたため、Claude Code は何もアップロードする前に公開を拒否しました。メッセージは Artifact ツール結果に表示され、修正する最初の位置を指定します。

```text wrap theme={null}
file_path: the source file is not valid UTF-8 text (first invalid byte at line 12, column 40). It may be saved in another encoding or contain binary data. Rewrite it as UTF-8, then publish again. Nothing was published.

file_path: the source file has the replacement character U+FFFD at line 12, column 40, usually left where an earlier edit or paste lost a character. Replace it with the intended text (in HTML, write an intended U+FFFD as &#xFFFD;), then publish again. Nothing was published.
```

Claude Code はファイルを UTF-8 としてデコードするか、リトルエンディアン UTF-16 バイトオーダーマークで始まる場合は UTF-16 としてデコードします。そのような UTF-16 ファイルがデコードされない場合、最初のメッセージは `UTF-16` を指定し、それでもファイルを UTF-8 として書き直すよう指示します。指定された位置の後にさらに位置が続く場合、メッセージは位置の後に `(+2 more)` などのカウントを追加します。

**What to do:**

* 通常は何もしません。Claude はファイルを書き直して再度公開します
* ファイルが自分で書いたものまたはエクスポートしたものである場合、UTF-8 として再度保存し、各 `U+FFFD` を以前の編集、貼り付け、または変換が失った文字に置き換えます
* ページに意図的な `U+FFFD` を表示するには、リテラル文字ではなく HTML で `&#xFFFD;` として書き込みます

v2.1.267 より前は、Claude Code はそのようなファイルをチェックなしでアップロードし、代わりにサーバーが公開を拒否していました。

<h3 id="not-published-that-file-is-on-a-network-share">
  Not published: that file is on a network share
</h3>

Claude が、ネットワークホストを指定するパスにあるファイルから [アーティファクト](/docs/ja/artifacts) を公開しようとしました。

* Windows では、起動時に [`--add-dir`](/docs/ja/cli-reference#cli-flags) で渡したマップ済みネットワークドライブの下にない `\\server\share` パス
* macOS または Linux では、`/net/<host>/page.html` などの自動マウントパス

このようなパスを参照すると、パスが指定するホストへの接続が発生し、Windows ではその接続によってホストに認証情報が送信される可能性があります。Claude Code はファイルの公開を拒否し、ファイルを読み取りません。拒否は Artifact ツール結果に表示されます。

```text theme={null}
Not published: that file is on a network share. Publish a file from this session's folders instead.
```

**What to do:**

* そのファイル自体が必要でない場合は、何もする必要はありません。メッセージは Claude に、代わりにセッション自身のフォルダからファイルを公開するよう指示します
* そのファイル自体を公開するには、ローカルディスク上のフォルダにコピーして、再度依頼します
* Windows で Claude が共有から直接公開できるようにするには、共有をドライブ文字にマップし、Claude Code の起動時にそのドライブを渡します。たとえば PowerShell では、`net use Z: \\server\share` を実行してから `claude --add-dir Z:\` を実行します。これで Claude はそのドライブからファイルを公開できます。セッション中に `/add-dir` でドライブを追加するだけでは不十分です。
* macOS または Linux では、`/mnt` や `/Volumes` の下などのディレクトリに共有をマウントし、自動マウントパスではなくそのパスから公開します

<h3 id="reading-a-local-file-from-outside-the-connected-folders">
  Reading a local file from outside the connected folders in a Cowork session
</h3>

Claude Desktop アプリでマシン上で実行されている [Cowork](https://claude.com/docs/cowork/overview) セッションで、Claude が [アーティファクト](/docs/ja/artifacts) 用のローカルファイルを指定しました。Claude Code はファイルがセッションの接続されたフォルダ内のプレーンファイルであることを確認できませんでした。パスはそれらのフォルダの外にあるか、シンボリックリンクを通過するか、見た目とは異なるファイルを指定しうる方法で記述されています。そのようなファイルを読み取るには承認が必要であり、すべての承認をスキップするように設定されたセッションなど、承認カードを表示できないセッションでは、Claude Code は読み取りを拒否します。

拒否は Artifact ツール結果に表示されます。ファイルをまったく検査できない場合、代わりにその失敗を指定します。

```text wrap theme={null}
Reading a local file from outside this session's connected folders, or through a link, needs the approval card, and no one can answer it in this Cowork session. Use a plain file inside the connected folders; do not retry this file in this session.

cannot read file_path (ENOENT) — the file could not be examined, and no one can answer the approval card in this Cowork session. Check that the file exists as a plain file inside the connected folders, then retry with that path.
```

**What to do:**

* 通常は何もしません。メッセージは Claude に接続されたフォルダ内のプレーンファイルを代わりに使用するよう指示します
* そのファイル自体をアーティファクトに入れるには、シンボリックリンクではなく通常のファイルとして、セッションの接続されたフォルダの 1 つにコピーして、再度依頼します

<h3 id="webfetch-cannot-fetch-localhost">
  WebFetch cannot fetch localhost
</h3>

Claude は [WebFetch](/docs/ja/tools-reference#webfetch-tool-behavior) を、`http://localhost:3000` や `http://wiki/` のような単独のイントラネット名など、ドットのないホスト名を持つ URL で呼び出しました。WebFetch はリクエストを行う前にこれらの URL を拒否します。

```text wrap theme={null}
WebFetch cannot fetch localhost or other hostnames without a dot. To reach a local server, use Bash with curl instead.
```

**What to do:**

* 通常は何もしません。メッセージは Claude を Bash ツール経由の `curl` に指示します。これはローカルおよびイントラネットサーバーに到達できます

v2.1.268 より前は、WebFetch はこれらの URL を汎用 `Invalid URL` エラーで報告していました。

<h3 id="webfetch-domain-safety-check-failed">
  WebFetch domain safety check failed
</h3>

URL をフェッチする前に、WebFetch は URL のホスト名を `api.anthropic.com` に送信して、Anthropic の [ドメイン安全ブロックリスト](/docs/ja/data-usage#webfetch-domain-safety-check) に対してチェックします。チェックが完了できない場合、WebFetch はドメインが安全であることを確認できないため、ページをフェッチせず、ツール結果は代わりにこれらのメッセージの 1 つを持ちます。

```text wrap theme={null}
The safety check for domain example.com is rate-limited (too many domain checks from this network; the limit is shared and can stay exhausted for minutes). Do not retry WebFetch in a loop or sleep to wait it out; continue without this page and report that its safety check was rate-limited. A single later attempt is fine; if that is rate-limited too, stop.

Unable to verify if domain example.com is safe to fetch. This may be due to network restrictions or enterprise security policies blocking claude.ai.
```

* `rate-limited`: チェックエンドポイントは HTTP `429` で応答しました。メッセージは Claude にページなしで続行し、後で最大 1 回だけ再度試すよう指示します。Claude Code は失敗したチェックをキャッシュしないため、そのドメインの後の取得はチェックを再度実行します。ネットワーク上のセッションがこれに頻繁に該当する場合、設定で [`skipWebFetchPreflight: true`](/docs/ja/settings-reference#skipwebfetchpreflight) を指定してチェックをスキップできます。
* `Unable to verify`: チェックリクエストが失敗した、タイムアウトした、または別のエラーステータスを受け取りました。ネットワークが `api.anthropic.com` をブロックする場合、そのドメインを許可リストに追加するか、設定で [`skipWebFetchPreflight: true`](/docs/ja/settings-reference#skipwebfetchpreflight) を指定してチェックをスキップします。

v2.1.286 より前は、レート制限メッセージは `The safety check for domain example.com is temporarily rate-limited (too many domain checks from this network). Retry after about a minute; retrying sooner will fail the same way.` と読みました。
v2.1.285 より前は、レート制限されたチェックは代わりに `Unable to verify` メッセージで報告されました。

<h2 id="background-session-errors">
  バックグラウンドセッションエラー
</h2>

[バックグラウンドセッション](/docs/ja/agent-view)は独自の対話型ターミナルなしで実行されるため、ターミナルが必要なコマンドはそこで異なる動作をします。これらのメッセージはバックグラウンドセッションのトランスクリプト、それに接続するターミナル、ディスパッチ元のセッションまたはシェル、または以下の[worktree-guard エントリ](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)の場合は worktree に分離されたセッションまたは worktree 分離サブエージェントを実行しているセッションに表示されます。メッセージが特定のサーフェスに固有の場合、そのエントリに記載されています。

<h3 id="commands-refused-in-a-background-session">
  バックグラウンドセッションで拒否されたコマンド
</h3>

対話型ダイアログを開くコマンドは、バックグラウンドセッションにターミナルが接続されていない間は実行できません。`/install-github-app`、`/mcp` 設定リスト、および MCP サーバーメニューの認証アクションは、メッセージで応答します。`/install-github-app` と `/mcp` 設定リストの場合、セッションは[エージェントビュー](/docs/ja/agent-view)の**入力が必要**に表示されるため、セッションを見つけて接続し、コマンドを再度実行できます。ターミナルが接続されている間、これらのコマンドは正常に機能します。

v2.1.216 より前では、`/install-github-app` または `/mcp` 設定リストが拒否された後、セッションは**入力が必要**に表示されませんでした。v2.1.213 から v2.1.215 では、ターミナルが接続されている間、コマンドは引き続き機能し、拒否メッセージは接続して再度コマンドを実行するよう指示していました。v2.1.208 から v2.1.212 では、Claude Code はターミナルが接続されている間でもこれらを拒否し、`Can't open MCP settings in a background session` などのメッセージが表示されていました。これらのバージョンでは、通常の `claude` セッションからコマンドを実行するか、アップグレードしてください。v2.1.208 より前では、バックグラウンドセッション内でダイアログが開きました。v2.1.208 のみで、Claude Code はバックグラウンドセッションの `/model` ピッカーも拒否し、`/upgrade` はブラウザを開く代わりにアップグレード URL を出力しました。

表現はコマンドに名前を付けます。`/mcp` 設定リストは以下を報告します：

```text theme={null}
Can't open MCP settings while no terminal is attached to this background session. This session now shows "needs input" in agent view — open it and run /mcp to manage servers, or use `/mcp enable|disable|reconnect <server>` to steer without the panel.
```

**対処方法：**

* エージェントビューからセッションに接続して、コマンドを再度実行します
* または、メッセージが名前を付けた形式を使用します。例えば `/mcp reconnect <server>`、`/mcp enable`、または `/mcp disable` は、接続せずに機能します

<h3 id="write-or-command-blocked-because-the-path-cannot-be-safely-resolved">
  パスを安全に解決できないため、書き込みまたはコマンドがブロックされました
</h3>

Claude は、[worktree 分離ガード](/docs/ja/agent-view#how-file-edits-are-isolated)が 1 つの検証可能な場所に解決できないスペルを通じてファイルまたは作業ディレクトリにアクセスしました。ガードは、[worktree に分離されたセッション](/docs/ja/worktrees#how-claude-code-enforces-isolation)（対話型またはバックグラウンド）および[worktree 分離サブエージェント](/docs/ja/worktrees#isolate-subagents-with-worktrees)での書き込みとコマンド作業ディレクトリをチェックします。シンボリックリンクを解決してから、操作が共有チェックアウトに到達しないことを確認します。解決に失敗すると、操作をブロックして、そこに到達させません。メッセージは、拒否するパス形式と再試行方法に名前を付けます：

```text theme={null}
This write was blocked because the path is spelled in a form that cannot be safely resolved (for example through a symlink storing a raw dot segment, a network-share or device-namespace shape, or an unreadable ancestor directory). If the file is inside the worktree /path/to/worktree, address it by its direct symlink-free path instead.
```

ブロックされたコマンドは、作業ディレクトリについて同じ原因を報告し、`re-run the command from its direct symlink-free path` で終わります。v2.1.217 より前では、ガードはシンボリックリンクを解決せずにパススペルを比較していたため、これらのスペルはブロックされず、シンボリックリンクを通じた書き込みは共有チェックアウトに到達する可能性がありました。

**対処方法：**

* 通常は何もしません：完全なメッセージは Claude にツールエラーとして送信され、Claude は名前を付けた直接パスで再試行します。ブロックされたファイル編集の場合、会話ビューには短い `Error editing file` 行のみが表示されます。完全なメッセージはトランスクリプトビューに表示されます。これは `Ctrl+O` で開きます。ブロックされたコマンドはコマンド出力に出力します。
* 同じファイルでブロックが繰り返される場合、パスは `docs/current -> ../README.md` など `..` を含むコミット済みシンボリックリンクを通じて実行される可能性があります。Claude にリンクを通じてではなく、実際のパスでターゲットファイルを編集するよう依頼してください

<h3 id="write-or-command-blocked-because-the-path-names-a-network-location">
  パスがネットワークロケーションに名前を付けているため、書き込みまたはコマンドがブロックされました
</h3>

Claude は、マシン上にないドライブ、`\\server\share\file` などの UNC 共有、または `/net` オートマウントパスに名前を付けるパスを通じてファイルまたは作業ディレクトリにアクセスしました。セッションのチェックアウトはローカルディスク上にあります。同じ[worktree 分離ガード](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)は、そのようなパスが共有チェックアウトから外れていることを確認できないため、操作をブロックします。セッションを worktree に分離してもブロックは解除されません。メッセージは、代わりに使用するパスの形式に名前を付けます：

```text theme={null}
This write was blocked because the path is network-shaped (a UNC share or /net automount spelling) while this session's checkout is local. Isolating cannot unblock it. If the file is genuinely inside the worktree /path/to/worktree, address it by its local, plainly-spelled path instead.
```

ブロックされたコマンドは、作業ディレクトリについて同じ原因を報告し、`re-run the command from its local, plainly-spelled path` で終わります。v2.1.217 より前では、ガードはパステキストのみを比較していたため、UNC または `/net` パスを通じてチェックアウト内のファイルにアクセスすることはブロックされませんでした。

**対処方法：**

* 通常は何もしません：Claude はメッセージが要求するローカルスペルで再試行します

<h3 id="command-blocked-by-the-worktree-isolation-checks">
  worktree 分離チェックによってコマンドがブロックされました
</h3>

Claude は、[worktree に分離されたセッション](/docs/ja/worktrees#how-claude-code-enforces-isolation)で Bash または Monitor コマンドを実行し、Claude Code は 2 つの理由のいずれかでそれを拒否しました：

* コマンドは git をメインチェックアウトに指します。
* Claude Code は、コマンドテキストからコマンドが実行する git が worktree 内に留まることを確認できません。git に名前を付けないコマンドでも、`${!name}` などの変数間接参照を展開するか、`${ command; }` などの Bash 関数置換を実行すると、実行時に生成される値自体がコマンドになり得るため、この理由で拒否される可能性があります。

メッセージの中央は、検証できなかったものに名前を付けます：

```text wrap theme={null}
This session is isolated in the worktree /path/to/worktree, but this command evaluates ${!x@P} arithmetically inside a construct too complex to verify, which can run a command hidden in a variable's value. Refusing to run it — a worktree-isolated session's git operations must target its own worktree. Split it into plain, separate commands and run them from /path/to/worktree.
```

**対処方法：**

* 通常は何もしません：Claude はメッセージを読み、最後の文が要求する方法でコマンドを書き直します
* 要求したコマンドが拒否され続ける場合、フラグが付いた値をリテラルでスペルします：間接参照または置換をその値に置き換え、git を worktree 内から独自のプレーンコマンドとして実行します
* メインチェックアウトで意図的に動作するには、セッション外のターミナルでコマンドを自分で実行します

<h3 id="this-session-has-no-saved-transcript">
  このセッションに保存されたトランスクリプトがありません
</h3>

停止した[バックグラウンドセッション](/docs/ja/agent-view)に接続しました。このセッションは `←` または `/background` で別の会話からバックグラウンドに移動され、最初の応答が完了する前に停止しました。その最初の応答が完了するまで、会話はバックグラウンドに移動した元のセッションにのみ存在するため、`claude attach` は停止したセッションの開始を拒否し、同じセッション ID で空白の会話を開始しません。メッセージは、このセッションの `claude respawn` コマンドで終わります：

```text theme={null}
This session has no saved transcript — it was stopped before its first response finished. If it was backgrounded from another conversation, that one is still intact; `claude respawn <id>` starts this one fresh.
```

[エージェントビュー](/docs/ja/agent-view)で同じセッションの行を開くと、リストの下に `Press enter again to restart this session fresh` が表示され、行の 2 番目の `Enter` はセッションを空の会話で再開します。v2.1.212 より前では、行を開くと拒否メッセージが表示され、エージェントビューから再開する方法がありませんでした。v2.1.211 より前では、停止したセッションを開くと、その空白の会話が静かに開始され、セッションの元のプロンプトを再実行できました。

**対処方法：**

* バックグラウンドに移動した会話は無傷です：[`claude --resume`](/docs/ja/sessions) で再開するか、そこで作業を続けます
* 停止したセッションを新しく開始するには、メッセージの ID で `claude respawn <id>` を実行するか、エージェントビューの行で `Enter` を 2 回押します
* セッションが応答を完了し、v2.1.214 より前のバージョンでこの拒否が表示される場合、`~/.claude/projects` の読み取り不可フォルダがトランスクリプトスキャンが保存された会話を見つけるのを妨げる可能性があります。v2.1.214 以降にアップグレードしてください。これはスキャン中に読み取り不可フォルダを許容します

<h3 id="this-session-is-running-in-another-terminal">
  このセッションは別のターミナルで実行されています
</h3>

[エージェントビュー](/docs/ja/agent-view)で停止したセッションの行を開きました。その保存された会話は、このマシン上の別のライブ Claude Code プロセスで既に開かれているため、Claude Code は同じトランスクリプトに書き込む 2 番目のプロセスの開始を拒否します。表示されるメッセージは、[会話を保持しているもの](/docs/ja/agent-view#opening-a-session-says-the-conversation-is-already-open)によって異なります：

```text theme={null}
Can't open — this session is running in another terminal
This conversation is already open in another running Claude session — use that one, or close it and try again
```

* **`running in another terminal`**：ターミナルが会話を保持しています。例えば、`claude --resume` または `/resume` で再開したターミナル。行には `Open in a terminal` も表示されます。
* **`already open in another running Claude session`**：別の非対話型 Claude Code プロセスがそれを保持しています。例えば、同じ会話の[バックグラウンドセッション](/docs/ja/agent-view#the-supervisor-process)プロセスがまだ終了していません。

Claude Code は、行を開くときに入力した返信を保存し、セッションが次に開始するときにセッションの次のプロンプトとして送信します。

**対処方法：**

* 会話を開いているプロセスで会話を続けるか、そのプロセスを終了して行を再度開きます

v2.1.248 より前では、`already open in another running Claude session` 拒否のみが存在していました：ターミナルで再開された会話は開いているとはカウントされず、行を開くと同じ会話に書き込む 2 番目の Claude Code プロセスが開始されました。

<h3 id="this-sessions-saved-conversation-is-no-longer-on-disk">
  このセッションの保存された会話はディスク上にもうありません
</h3>

[バックグラウンドセッション](/docs/ja/agent-view)を開きました。このセッションはバックグラウンドサービスがオフの間に終了し、[トランスクリプトクリーンアップ](/docs/ja/settings-reference#cleanupperioddays)がその保存された会話を削除しました。例えば、マシンが数週間オフになった後です。通常、そのような行を開くと、[保存された会話を再開](/docs/ja/agent-view#sessions-show-as-failed-after-shutdown)します。再開するものがないため、Claude Code は、確認なしにセッションの元のプロンプトを再実行するのではなく、拒否します：

```text theme={null}
This session's saved conversation is no longer on disk (it ended while the background service was off, and old transcripts are cleaned up), so there is nothing to resume. `claude rm 7c5dcf5d` deletes the row; `claude respawn 7c5dcf5d` runs its original prompt again instead.
```

`claude attach <id>` はこのテキストを出力します。エージェントビューでは、フッターはより短く、`ctrl+x deletes the row` で終わります。

**対処方法：**

* `claude rm <id>` を実行して行を削除します。[保持されたケース](/docs/ja/agent-view#what-deleting-a-session-removes)の 1 つが適用される場合、`claude rm` は行と worktree を保持し、理由に名前を付けます
* セッションの元のプロンプトを新しい会話として再度実行するには、`claude respawn <id>` を実行します

v2.1.248 より前では、そのような行を開くと、拒否する代わりにセッションの元のプロンプトを再実行し、数週間前のタスクをフォアグラウンドに引き戻しました。

<h3 id="worktree-has-commits-that-are-not-pushed-anywhere">
  Worktree にはどこにもプッシュされていないコミットがあります
</h3>

[バックグラウンドセッション](/docs/ja/agent-view#what-deleting-a-session-removes)を削除しようとしました。その worktree は、Claude Code が他の場所に保存されていることを確認できないコミットを保持しています。Claude Code は、コミットを見ずに破棄するのではなく、worktree とセッション行を保持します。`claude rm` はブランチとプッシュされていないコミットに名前を付け、進め方を説明します：

```text theme={null}
kept 7c5dcf5d — its worktree is still at “/home/you/project/.claude/worktrees/fix-login”
  2 unpushed commits on “claude/fix-login”: a1b2c3d “Fix login flow” and 1 more. They exist on no remote, so deleting the worktree would lose them.
  push them and run 'claude rm 7c5dcf5d' again, or discard the worktree and its commits: claude rm 7c5dcf5d --discard-unpushed a1b2c3d000000000000000000000000000000000@0123456789abcdef0123456789abcdef
```

Claude Code がコミットを要約できない場合、詳細行は代わりに `The worktree has unpushed commits` となります。[エージェントビュー](/docs/ja/agent-view)では、セッションの行は同じ理由で `not deleted` を表示します。

リモート上のコミットは削除をブロックしません。`origin` リモートのデフォルトブランチのローカルコピー上のコミットもブロックしません。ただし、そのブランチがメインチェックアウト（worktree ではなく、リポジトリディレクトリ自体）でチェックアウトされている限りです。

**対処方法：**

* コミットを保持するには、worktree のブランチをプッシュするか、メインチェックアウトでチェックアウトされたデフォルトブランチにマージしてから、セッションを再度削除します
* コミットを破棄するには、メッセージが出力した `claude rm <id> --discard-unpushed` コマンドを実行するか、エージェントビューのセッション行で再度 `Ctrl+X` を 2 回押します。これにより、セッション、worktree、そのブランチ、プッシュされていないコミット、およびコミットされていない変更が削除されます。worktree が拒否以降にコミットを獲得した場合、Claude Code はそれを再度保持し、更新された状態を表示します
* メッセージが worktree が別の完了したセッションによっても記録されていることを示す場合、再度削除してもそれは破棄されません：コミットをプッシュしてから、セッションを再度削除します

v2.1.268 より前では、`claude rm` はコミット要約を `kept` 行自体に置いていました。`claude rm` がコミットを要約できない場合、`kept` 行は要約の代わりに `worktree has commits that are not pushed anywhere` となっていました。

v2.1.260 より前では、メッセージはブランチまたはコミットに名前を付けず、再度削除することは同じ方法で拒否されました：セッションを削除してプッシュしないことは、`git worktree remove --force <path>` で worktree を自分で削除してから、`claude rm <id>` を再度実行することを意味していました。

v2.1.248 より前では、メインチェックアウトでチェックアウトされたデフォルトブランチはカウントされませんでした：既にそこにマージしたブランチは、そのコミットがリモートに到達するまで、この拒否をトリガーしました。

<h3 id="terminal-host-process-died">
  ターミナルホストプロセスが終了しました
</h3>

各[バックグラウンドセッション](/docs/ja/agent-view)のターミナルはバックグラウンドサービスの下のホストプロセスで実行され、そのプロセスはサービスがその接続を保持している間に終了したため、セッションに到達できませんでした。

Linux と WSL では、バックグラウンドサービスは数秒ごとに各ホストプロセスをチェックし、プロセスが終了しているがサービスへの接続が閉じられていない場合、セッションを失敗とマークし、[エージェントビュー](/docs/ja/agent-view#read-session-state)の行に理由を表示します：

```text theme={null}
terminal host process died — press Enter to restart
```

シェルから、`claude attach <id>` は既に死んだホストで失敗とマークされたセッションを再開し、そうでなければ原因を出力して終了します：

```text theme={null}
Couldn't attach to <id> — This session's terminal host process died (the conversation is saved) — run `claude attach <id>` again to restart it on a fresh host.
```

会話はどちらの場合でも保存されます。

[シェルコマンド](/docs/ja/agent-view#run-a-shell-command)を実行している行は代わりに `terminal host process died — its output is gone; the command was not run again` を表示し、`claude attach` は `This command's terminal host process died — its output is gone and the command was not run again` を出力します。Claude Code はコマンドを再実行することはありません。

**対処方法：**

* エージェントビューで、失敗した行で `Enter` を押します。セッションは新しいホストプロセスで再開され、会話が再開されます
* シェルから、`claude attach <id>` を再度実行します。Claude Code は `Session <id>'s terminal host died — restarting it on a fresh one…` を出力し、セッションを再度開きます
* シェルコマンド行をこの方法で再開することはできません。コマンドを再度ディスパッチして再実行します

v2.1.247 より前では、死んだホストプロセスはバックグラウンドサービスが実行したすべての生存性チェックに合格する可能性があったため、セッションを開くと `opening… · esc to cancel` が無期限に表示され、`claude attach <id>` はエラーを報告せずに待機していました。

<h3 id="session-isnt-responding">
  セッションが応答していません
</h3>

[バックグラウンドセッション](/docs/ja/agent-view)を開きました。バックグラウンドサービスは開くことを受け入れましたが、約 10 秒間出力が到着しなかったため、Claude Code は、セッションのターミナルをリレーするプロセスが出力を配信できないと結論付け、待機する代わりに試行を終了します。

エージェントビューでは、Claude Code はフッターで再開を提供します：

```text theme={null}
Press enter again to restart this session — it isn't responding (its conversation is saved and resumes).
```

シェルから、`claude attach <id>` は原因を出力して終了します：

```text theme={null}
Couldn't attach to <id> — Session isn't responding — `claude stop <id>`, then `claude attach <id>` restarts it (the conversation is saved).
```

Claude Code は、[シェルコマンド](/docs/ja/agent-view#run-a-shell-command)を実行している行を再開することはありません。再開するとコマンドが再度実行されるためです。

**対処方法：**

* エージェントビューで、同じ行で `Enter` を再度押します。Claude Code は応答しないプロセスを停止し、セッションを再開し、会話が再開されます。2 番目のプレスなしに何も停止されません
* シェルから、`claude stop <id>` を実行してから、`claude attach <id>` を実行します
* シェルコマンド行の場合、エージェントビューで `Ctrl+X` を押すか、`claude stop <id>` を実行してそれを停止します。コマンドを再度ディスパッチして再実行します

<h3 id="session-was-stopped-while-the-respawn-was-in-flight">
  セッションは respawn が進行中に停止されました
</h3>

[バックグラウンドセッション](/docs/ja/agent-view)を開きました。そのプロセスは実行されていなかったため、Claude Code はそれを再開していました。その間に、別の Claude Code プロセスがそれを停止しました。例えば、別のターミナルで `claude stop` を実行しました。Claude Code はセッションを停止したままにします：

```text theme={null}
Session <id> was stopped while the respawn was in flight
```

ディスパッチしたばかりのセッションを開く場合、そのプロセスがまだ開始中の間、プロセスの開始を待ちます。v2.1.246 より前では、その時点でそれを開くと、それを停止してこのメッセージを表示する可能性がありました。

**対処方法：**

* セッションを停止しなかった場合、エージェントビューで行を再度開くか、`claude respawn <id>` を実行して再開します
* セッションを自分で停止した場合、残っているものはありません：セッションは停止したままです

<h3 id="session-agent-no-longer-available">
  セッションエージェントはもう利用できません
</h3>

`--agent` または `agent` 設定で開始された[カスタムエージェント](/docs/ja/sub-agents#invoke-subagents-explicitly)を実行していたセッションを再開しましたが、Claude Code はその名前のエージェントを見つけられませんでした。Claude Code は、[そのワークスペースを信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust)している場合はまずセッションの元のディレクトリを検索し、次に再開元のディレクトリを検索します。セッションは引き続き再開されますが、デフォルトツールを使用するため、エージェントのツール制限は適用されなくなります：

```text theme={null}
This session was running agent 'code-reviewer', which is no longer available (no agent by that name in /home/you/project). Continuing with the default tools and system prompt — the agent's tool restrictions no longer apply. To restore it, re-create the agent, or resume with an explicit --agent <name>.
```

警告は、Claude Code が検索したディレクトリのみに名前を付け、[バックグラウンドセッション](/docs/ja/agent-view)を起動するか、`/resume` または `claude --resume` を実行するか、[非対話モード](/docs/ja/headless)で再開するかどうかに関わらず、再開された会話に表示されます。非対話モードでは stderr にも送信されます。`--input-format stream-json` を使用するセッションは、Agent SDK がスタートアップ後にエージェントを提供するため、表示されません。

Claude Code はセッションへのフォールバックを保存しないため、警告は、対処するまで各再開で繰り返されます。組み込みの `claude` エージェントは、デフォルトツールセットへのフォールバックがそれに対して何も変わらないため、警告をトリガーしません。v2.1.216 より前では、Claude Code は静かにデフォルトエージェントとして続行し、ルックアップは再開するディレクトリのみをカバーしていたため、プロジェクトスコープのエージェントは別のディレクトリから再開すると失われました。

**対処方法：**

* セッションのプロジェクトの `.claude/agents/<name>.md` または個人エージェントの `~/.claude/agents/<name>.md` にエージェントファイルを再作成してから、再度再開します
* または、存在するエージェントを指定して `--agent <name>` で再開し、セッションをそのエージェントとして実行します
* エージェントがプロジェクトスコープで、セッションの元のディレクトリを信頼していない場合、そこで Claude Code を 1 回実行し、信頼ダイアログを受け入れてから、再度再開します

<h3 id="claude_code_process_wrapper-launcher-errors">
  CLAUDE\_CODE\_PROCESS\_WRAPPER ランチャーエラー
</h3>

[`CLAUDE_CODE_PROCESS_WRAPPER`](/docs/ja/corporate-launcher)が設定されており、その値は使用できないため、Claude Code はランチャーなしで実行するのではなく、影響を受けるプロセスの開始を拒否します。設定の問題は、変数名で始まり、理由を述べるメッセージで報告されます。例えば：

```text theme={null}
CLAUDE_CODE_PROCESS_WRAPPER: launcher `/opt/corp/launcher` is not an executable regular file
```

開始するが Claude Code で自分自身を置き換えずに終了するランチャーは、それが開始していたセッションを失敗させ、エージェントビューのセッション行は、ランチャーが `must exec, not daemonize` であることを、ランチャーが出力したものに続けて報告します。ランチャーが原因で開始できない、またはバックグラウンドサービスに到達できないセッションは、ランチャーの問題を理由として `Couldn't reach the background service (...)` 内で報告します。

**対処方法：**

* 変数を、`exec "$@"` を呼び出して終了する実行可能ファイルの絶対パスに設定します。完全な契約については、[ランチャー契約](/docs/ja/corporate-launcher#the-launcher-contract)を参照してください
* `/status` をチェックします。これは Self-exec エントリで解決された起動コマンドを表示し、実行中のバックグラウンドサービスが一致しない場合に警告します。または、シェルから `claude daemon status` を実行します
* [設定](/docs/ja/corporate-launcher#set-up-the-launcher)の `env` ブロックで値を修正した後、`claude daemon stop --any` でバックグラウンドサービスを再開して、次のディスパッチがラップされたものを開始するようにします

<h3 id="eunknown-when-starting-a-background-session">
  バックグラウンドセッションを開始するときの EUNKNOWN
</h3>

Windows は標準名を持たないエラーコードでプログラムの開始を拒否したため、失敗は `EUNKNOWN` として表示されます。通常のトリガーはソフトウェア制限ポリシー（グループポリシーや AppLocker など）で、開始されるプログラムをブロックしています。エラーは、`/background` または `claude --bg` で[バックグラウンドセッション](/docs/ja/agent-view)を開始するときに表示されます：

```text theme={null}
Couldn't reach the background service (spawn background service: EUNKNOWN: unknown error, uv_spawn) — run 'claude daemon status'
```

一部のアカウントでは、メッセージは `background service` の代わりに `daemon` を示しています。

npm インストールでは、`npm install -g @anthropic-ai/claude-code` がバイナリを置き換えている間に表示される `EUNKNOWN` は、[再インストール中の `EACCES`](#eacces-when-starting-a-background-session)と同じ原因を持ち、インストール完了後に再試行するとクリアされます。

Claude Code は PowerShell を通じてバックグラウンドサービスを開始するため、ターミナルを閉じてもサービスが存続します。PowerShell 7 がインストールされている場合はそれを使用し、そうでない場合は Windows PowerShell 5.1 を使用します。どちらの PowerShell も実行できない場合、Claude Code は代わりにサービスを直接開始するため、PowerShell のみをブロックするポリシーはこのエラーを引き起こしません。

v2.1.212 より前では、Claude Code は Windows PowerShell 5.1 のみを使用してサービスを開始していたため、グループポリシーが PowerShell 5.1 をブロックしたマシンは、PowerShell 7 がインストールされていても `Couldn't start the session — EUNKNOWN: unknown error, uv_spawn` で失敗しました。

**対処方法：**

* メッセージが `Couldn't start the session` となっている場合、v2.1.212 以降にアップグレードします。以前のバージョンでは、別のターミナルで最初に `claude daemon run` を実行してから、バックグラウンドセッションを再度開始することもできます。そのコマンドはバックグラウンドサービスをターミナルのフォアグラウンドで実行するため、サービスはそのターミナルが開いている限り続きます。
* npm インストールがバイナリを置き換えていた場合、完了するまで待ってから、バックグラウンドセッションを再度開始します
* npm インストールが実行されていないのに v2.1.212 以降でエラーが表示される場合、制限ポリシーが Claude Code 実行可能ファイルをブロックしているかどうかを Windows 管理者に確認します
* ターミナルを閉じるとバックグラウンドサービスが停止する場合、Claude Code は PowerShell なしでそれを開始しました。PowerShell 7 をインストールするか、管理者に PowerShell をブロック解除するよう依頼して、サービスがターミナルより長く続くようにします。

<h3 id="eacces-when-starting-a-background-session">
  バックグラウンドセッションを開始するときの EACCES
</h3>

Claude Code は、バックグラウンドセッションをホストする[バックグラウンドサービス](/docs/ja/agent-view#the-supervisor-process)を開始するために、独自のバイナリを実行できませんでした。npm インストールでは、これは通常、`npm install -g @anthropic-ai/claude-code` がその時点でバイナリを置き換えていたことを意味します。ユーザーが実行したか、[自動アップデーター](/docs/ja/setup#auto-updates)が実行したかは問いません。エラーは、[エージェントビュー](/docs/ja/agent-view)からセッションを開くときに表示されます：

```text theme={null}
Couldn't start the background service — spawn background service: EACCES: permission denied, posix_spawn '/usr/local/lib/node_modules/@anthropic-ai/claude-code/bin/claude'
```

`/background` または `claude --bg` でセッションを開始する場合、同じ理由は `Couldn't reach the background service (...)` 内に表示されます。同じ再インストールウィンドウ中に、エラーは `ENOENT` または `ENOEXEC` などの別のコードに名前を付けることができます。または Windows では `EUNKNOWN` または `EPERM`。再試行全体で持続する `EUNKNOWN` は[異なる原因](#eunknown-when-starting-a-background-session)を持っています。

npm インストールでは、Claude Code は再インストールが完了するのを待ち、独自に再試行します：最大 10 秒、および Claude Code の npm インストールがマシン上で明らかにまだ実行されている間、最大 2 分。これは別の Claude Code プロセスがアップデートをダウンロードしている場合をカバーします。インストールがその待機を超える場合、失敗は裸のエラーコードではなくアップデートに名前を付けます：

```text theme={null}
Claude Code is being updated by npm on this machine (still not runnable after 2 min, EACCES) — try again when the update finishes
```

v2.1.257 より前では、待機はすべての場合で 10 秒で停止していたため、別の Claude Code プロセスがまだアップデートをダウンロードしている間にこのエラーが表示されました。v2.1.246 より前では、Claude Code は待機なしで直ちに失敗しました。

**対処方法：**

* 数秒待ってから、セッションを開くか再度ディスパッチします。メッセージが Claude Code が更新されていることを示す場合、アップデートが完了した後に再試行します。
* npm インストールが実行されていない間にエラーが持続する場合、ユーザーはインストールされたバイナリを実行できません。その権限とそのディレクトリの権限をチェックするか、Claude Code を再インストールします。

<h3 id="background-service-exited-before-it-became-reachable">
  バックグラウンドサービスが到達可能になる前に終了しました
</h3>

Claude Code が[バックグラウンドサービス](/docs/ja/agent-view#the-supervisor-process)として開始したプロセスは、接続を受け入れる前に終了したため、Claude Code はセッションを開くことができませんでした。サービスが終了する前にエラーを出力した場合、括弧内の理由は終了コードまたはシグナルと、サービスが出力した最初の行を示します。これはそれを停止したものに名前を付けます：

```text theme={null}
Couldn't reach the background service (background service exited before it became reachable (exit code N): <the service's first error line>) — run 'claude daemon status'
```

[エージェントビュー](/docs/ja/agent-view)からセッションを開く場合、同じ理由は `Couldn't start the background service —` に続きます。サービスが終了する前に何も出力しなかった場合、メッセージは代わりに `nothing on stderr` を示しています。

Claude Code はサービスのエラー行で失敗を報告します。v2.1.246 より前では、失敗は 45 秒の待機後にのみ表示され、`background service did not become reachable within 45s` として、サービスのエラー行なしで表示されました。

2 つの引用された理由は既知の原因を持っています：

* `Error: claude native binary not installed.`：npm インストールがその時点で Claude Code バイナリを置き換えていたため、サービスは npm のプレースホルダーを実行しました。インストール完了後に再試行します。インストールが実行されていない間に行が持続する場合、[npm インストールを完了](/docs/ja/troubleshoot-install#native-binary-not-found-after-npm-install)します。v2.1.257 より前では、macOS npm 自己更新はインストールウィンドウ中のすべての開始でこの失敗を生成しました。
* Windows で、すべての開始で終了コード 1 で `nothing on stderr`：`daemon.lock` は、Claude Code がシグナルを送信することも、消えたことを証明することもできないプロセスに名前を付けます。そのため、各新しいサービスは別のサービスがロックを保持していると結論付け、終了します。Claude Code が書き込み元の消失を証明できるロックは、独自に置き換えられ、この失敗を生成しません。失敗がすべての開始で繰り返される場合、`~/.claude/daemon.lock` を削除してから、セッションを開くか再度ディスパッチします。v2.1.257 より前では、そのようなロックはファイルを削除するまですべての開始をブロックしました。

**対処方法：**

* メッセージが行を引用する場合、それが名前を付けるものを修正してから、セッションを開くか再度ディスパッチします。次の試行はサービスを再度開始します
* `claude daemon status` を実行して、サービスが現在実行されているかどうかをチェックします

<h3 id="working-directory-no-longer-exists-when-starting-a-background-session">
  バックグラウンドセッションを開始するときに作業ディレクトリが存在しなくなりました
</h3>

[バックグラウンドセッション](/docs/ja/agent-view)を開始したディレクトリが、セッションの開始中に削除されました。Claude Code はセッションを開始せず、メッセージは見つからないディレクトリに名前を付けます：

```text theme={null}
Couldn't start a background session (working directory no longer exists or is not accessible: /tmp/demo)
```

v2.1.257 より前では、セッションは開始されたように見え、その後エージェントビューで同じ理由で失敗した行として表示されました。

v2.1.281 より前では、このメッセージはセッションを開始する前にディレクトリが既に消えていた場合にも表示されました。そのケースは[`could not be resolved on disk`](#workspace-not-trusted-when-dispatching-a-background-session)を報告します。

**対処方法：**

* メッセージが名前を付けるディレクトリを再作成するか、存在するディレクトリからディスパッチしてから、再度試してください

<h3 id="workspace-not-trusted-when-dispatching-a-background-session">
  バックグラウンドセッションをディスパッチするときにワークスペースが信頼されていません
</h3>

[信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust)していないディレクトリで[バックグラウンドセッション](/docs/ja/agent-view)を開始または再開しましたが、ワークスペース信頼ダイアログを表示して確認することができませんでした。Claude Code はセッションを開始しません：

```text theme={null}
Workspace not trusted. Run `claude` in /path/to/project once and accept the trust prompt, then retry.
```

セッション自体のディレクトリのターミナルから、同じコマンドは代わりに信頼ダイアログを表示し、受け入れるとセッションを開始します。このメッセージは、スクリプトなど、ダイアログが表示できない場所に表示されます。または、別のディレクトリからセッションを再開するときに表示されます。

2 つのバリアントは異なる原因に名前を付けます：

* **`The home directory is trusted one session at a time`**：セッションのディレクトリはホームディレクトリです。Claude Code はホームディレクトリの信頼を保存しないため、以前のセッションでそこでダイアログを受け入れてもカウントされません。
* **`<path> could not be resolved on disk`**：Claude Code はディスク上のセッションのディレクトリを見つけることができませんでした。

v2.1.286 より前の Windows では、信頼の記録がパスの大文字・小文字が異なる形で保存されていた場合、既に信頼したディレクトリでもこのメッセージが表示されることがありました。v2.1.286 以降にアップデートしてください。

**対処方法：**

* メッセージが名前を付けるディレクトリで `claude` を実行し、信頼ダイアログを受け入れてから、コマンドを再度実行します
* ホームディレクトリメッセージの場合、ホームディレクトリのターミナルからコマンドを実行してダイアログが表示されるようにするか、プロジェクトディレクトリからセッションを開始します
* `could not be resolved on disk` メッセージの場合、ディレクトリを再作成するか、存在するディレクトリから新しいセッションを開始します

<h2 id="wrapper-and-ide-errors">
  ラッパーと IDE エラー
</h2>

これらのエラーは、IDE 拡張機能や [Agent SDK](/docs/ja/agent-sdk/overview) アプリケーションなど、Claude Code を起動したプログラムから発生します。Claude Code 自体からではなく、ラッパーから発生するものです。

<h3 id="claude-code-process-exited-with-code-n">
  Claude Code プロセスがコード N で終了しました
</h3>

基盤となる `claude` プロセスがゼロ以外のコードで終了しました。終了コードだけでは何が失敗したかは分かりません。実際のエラーはプロセス自体の出力にあり、ラッパーはキャプチャした場合はそれを追加し、そうでない場合はログに保持します。

```text theme={null}
Error: Claude Code process exited with code 1
```

Windows では、ネイティブビルドはターンが完了した直後にコード `4294967295` で終了することがあります。その終了がターン境界に着地し、待機中のメッセージがなく、バックグラウンドタスクが実行されていない場合、[VS Code 拡張機能](/docs/ja/vs-code) はこのエラーを表示する代わりに、セッションを静かに閉じます。次のメッセージで会話が再開されます。

v2.1.273 より前では、拡張機能は何も失われていないにもかかわらず、すべてのターン境界でそのエラーを表示していました。

**対応方法：**

* VS Code では、エラーと共に表示される **View output logs** リンクをクリックして、基盤となるエラーを確認してください
* Agent SDK アプリケーションでは、メッセージループの周りでエラーをキャッチしてください。[CLI プロセス終了](/docs/ja/agent-sdk/troubleshooting#cli-process-exit) の下のエントリは、各 SDK 言語でコードが受け取るものをカバーしています。
* 同じプロジェクトのターミナルで `claude` を実行してください。通常、失敗はそこで実際のエラーメッセージと共に再現され、このページで検索できます。
* ターミナルで `claude doctor` を実行して、インストールと設定を確認してください

<h3 id="could-not-locate-the-claude-cli-on-path">
  Claude CLI が PATH に見つかりません
</h3>

[VS Code 拡張機能](/docs/ja/vs-code) は、Windows で統合ターミナルで Claude Code を開き、ターミナルのシェルが PowerShell で、拡張機能がインストールされた `claude` 実行ファイルを PATH で見つけられない場合、このエラーを表示します。拡張機能は、インストールされた `claude` を PATH で見つけるまで Claude Code の起動を拒否します。

```text theme={null}
Failed to run Claude Code: Error: Could not locate the Claude CLI on PATH. Launching by name in a PowerShell terminal would run a 'claude' from the open folder instead of the installed CLI, so the launch was blocked. Make sure the Claude CLI's install directory is on your system PATH (not only your PowerShell profile), then restart VS Code and try again. VS Code reads PATH when it starts, so PATH changes take effect only after a restart.
```

**対応方法：**

* VS Code の外で新しい PowerShell ウィンドウを開き、`where.exe claude` を実行してください。パスが出力されない場合、CLI は PATH にありません。[PATH を確認する](/docs/ja/troubleshoot-install#verify-your-path) に従ってインストールディレクトリを追加してください。パスが出力される場合、エントリは PowerShell プロファイルから、または VS Code がまだ取得していない PATH 変更から来ています。次の 2 つのステップがこれらのケースをカバーしています。
* PATH エントリを PowerShell プロファイルではなく、ユーザーまたはシステム環境変数として設定してください。拡張機能はプロファイルを実行しないため、そこにのみ存在する PATH 編集は拡張機能に到達しません。
* PATH を変更した後、VS Code を再起動してください。拡張機能は VS Code が起動時にキャプチャした PATH をチェックするため、PATH 変更は再起動後にのみ有効になります。

<h3 id="the-connection-to-claude-code-ended-before-this-message-completed">
  Claude Code への接続がこのメッセージの完了前に終了しました
</h3>

[VS Code 拡張機能](/docs/ja/vs-code) はメッセージを `claude` プロセスに送信し、プロセスが確認または完了する前に接続がエラーなしで終了しました。拡張機能はメッセージが処理されたかどうかを判断できないため、再度送信するよう求めます。

```text theme={null}
The connection to Claude Code ended before this message completed — it may not have been processed, so please send it again.
```

**対応方法：**

* メッセージを再度送信してください。次のメッセージは会話を再開する新しい `claude` プロセスを開始します。
* 繰り返される場合は、同じプロジェクトのターミナルで `claude` を実行してください。プロセスを終了し続ける失敗は通常、そこで実際のエラーメッセージと共に再現されます。

<h2 id="rewind-warnings-and-errors">
  Rewind の警告とエラー
</h2>

これらのメッセージは、[`/rewind`](/docs/ja/checkpointing) コード復元から発生します。`Restored the code, but skipped N files` は Claude Code が一部のパスをスキップしたことを示す警告です。`No files were restored` は何も復元されなかったことを意味するエラーです。

<h3 id="restored-the-code-but-skipped-files">
  Restored the code, but skipped files
</h3>

`/rewind` コード復元は、1 つ以上の追跡パスをスキップしました。これらのパスに対して書き込みまたは削除を行いませんでした。Claude Code は以下の場合にパスをスキップします。

* シンボリックリンク、ハードリンク、またはその他の通常ファイル以外のファイルである、またはそうなった場合
* チェックポイント以降にそのディレクトリが変更された場合
* バックアップを安全に読み取ることができない場合

スキップされたパスは現在の内容を保持します。v2.1.216 より前では、`/rewind` は追跡パスのリンクを通じて書き込みと削除を行い、部分的な復元を報告しませんでした。

```text theme={null}
Restored the code, but skipped 2 files: the tracked path is (or became) a link or other non-regular file, its directory changed since the checkpoint, or its backup could not be safely read. Skipped files were left untouched — run with --debug for the paths.
```

**対応方法：**

* スキップされたファイルを特定して、以下の手順で各ファイルを処理してください。メッセージはカウントのみを示します。`~/.claude/debug/<session-id>.txt` のデバッグログには、復元の実行時に各スキップされたパスが記載されます。次の復元の前に `/debug` でデバッグログを有効にしてください。macOS または Linux では、代わりにリンクを直接見つけることができます。シンボリックリンクの場合は `find . -type l`、ハードリンクされたファイルの場合は `find . -type f -links +1` を実行してください。
* スキップされたファイルが、dotfile マネージャーで管理されている設定ファイルや pnpm などのツールでハードリンクされたファイルなど、意図的に作成したリンクである場合、rewind はその内容をそのままにしました。セッションの変更を元に戻すには、Claude にその編集を逆にするよう依頼するか、ファイルを自分で編集してください。
* リンクを作成していない場合は、その内容を信頼する前にパスを検査してください。

<h3 id="no-files-were-restored">
  No files were restored
</h3>

Claude Code は、[`/rewind`](/docs/ja/checkpointing) でコードを復元しようとしたときにそのチェックポイント内のファイルを復元できない場合、このメッセージを表示します。各ファイルについて、Claude Code が編集前に保存したバックアップが見つからないか、Claude Code がファイルに書き込みまたは削除できませんでした。

```text theme={null}
Failed to restore the code:
No files were restored: 1 file failed (backup missing, or the file could not be updated)
```

Claude Code は、[retention sweep](/docs/ja/claude-directory#cleaned-up-automatically) でセッションのバックアップを削除します。デフォルトではセッションが最後にバックアップを保存してから約 30 日後です。その後にセッションを再開した場合、`/rewind` はそのチェックポイントをリストしますが、そのいずれかに rewind すると、このエラーで失敗する可能性があります。メッセージに `N paths were skipped for link safety` も表示されている場合は、これらのパスについて [Restored the code, but skipped files](#restored-the-code-but-skipped-files) を参照してください。

セッションをフォークする場合（例えば [`--fork-session`](/docs/ja/cli-reference#cli-flags) または [`/branch`](/docs/ja/sessions#branch-a-session) を使用する場合）、Claude Code は元のセッションのバックアップをフォークにコピーします。Claude Code がバックアップをコピーできない場合（例えばディスクがいっぱいの場合）、そのバックアップはフォークに存在しません。それを必要とするチェックポイントに rewind すると、このエラーで失敗する可能性があります。

**対応方法：**

* 別の方法で変更を元に戻してください。Claude に編集を逆にするよう依頼するか、バージョン管理からファイルを復元してください。バックアップがなくなると、`/rewind` を再度実行しても同じ方法で失敗します。
* Claude Code がファイルに書き込みまたは削除できない場合は、ファイル権限など書き込みをブロックしているものを修正してから、`/rewind` を再度実行してください。
* 今後のセッションでバックアップをより長く保持するには、[`cleanupPeriodDays`](/docs/ja/settings-reference#cleanupperioddays) を増やしてください。

v2.1.260 より前では、Claude Code はバックアップが見つからないファイルをサイレントにスキップし、rewind が成功したように見えました。

<h2 id="session-saving-warnings">
  セッション保存の警告
</h2>

Claude Code は、セッショントランスクリプトを保存していない場合、入力ボックスの下の永続的な行に以下の警告を表示します。セッションはどちらの場合でも機能し続けます。警告は、後で [`--resume`](/docs/ja/sessions) でセッションが見つからない可能性があることを示しています。

<h3 id="transcript-writes-are-failing">
  トランスクリプト書き込みが失敗しています
</h3>

Claude Code は作業中にトランスクリプトをディスクに保存し、[トランスクリプトファイル](/docs/ja/sessions#where-transcripts-are-stored) への書き込みが失敗しています。メッセージは原因を基になるエラーコードで示します。例えば、ディスクがいっぱいの場合：

```text theme={null}
Transcript writes are failing (disk full — ENOSPC) · recent messages may not be saved for resume
```

警告は、エラーに応じて異なるポイントで表示されます：

* 自動的にクリアされない条件での最初の失敗：ディスクがいっぱい、ディスククォータを超過、ファイルシステムが読み取り専用、パスがファイルシステムの長さ制限を超過、または macOS と Linux では権限エラー
* 少なくとも 1 分間にわたる繰り返しの失敗（Windows での権限エラーを含む、ウイルス対策スキャンが単一の書き込みに失敗してから再試行で成功する場合など）

v2.1.217 より前では、Claude Code は失敗した書き込みを警告なしにドロップし、後で `--resume` で最近のメッセージが見つからないことが最初の兆候でした。

**対応方法：**

* エラーコードが示す条件を修正します：`ENOSPC` の場合はディスク容量を解放、`EDQUOT` の場合はクォータを引き上げるかクリア、`EACCES`、`EPERM`、または `EROFS` の場合はトランスクリプト位置への書き込みアクセスを復元
* 警告は次の書き込み成功時に自動的にクリアされます。再起動は不要です
* 警告が表示されている間に送信されたメッセージは、後でセッションを再開するときに見つからない可能性があります

<h3 id="transcript-saving-is-off-skip-prompt-history">
  CLAUDE\_CODE\_SKIP\_PROMPT\_HISTORY が設定されているため、トランスクリプト保存がオフになっています
</h3>

このセッションは [`CLAUDE_CODE_SKIP_PROMPT_HISTORY`](/docs/ja/env-vars) が設定された状態で開始されたため、Claude Code はこのセッションのトランスクリプトまたはプロンプト履歴を書き込みません：

```text theme={null}
Transcript saving is off — CLAUDE_CODE_SKIP_PROMPT_HISTORY is set · --resume will not find this session; if unintended, unset it and restart
```

この変数は、一時的なスクリプト化されたセッションの意図的なオプトアウトですが、シェルプロファイル、ラッパースクリプト、またはそれをエクスポートした親プロセスを通じてセッションに到達することもあります。

**対応方法：**

* 変数を意図的に設定した場合、アクションは不要です。通知は、セッションが `--resume`、`--continue`、または上矢印履歴に表示されないことを確認します
* 設定していない場合は、`claude` を起動するシェルまたはスクリプトから変数を削除し、新しいセッションを開始します。現在のセッションからのメッセージは遡及的に保存されません。

<h3 id="transcript-saving-is-off-child-session-marker">
  CLAUDE\_CODE\_CHILD\_SESSION マーカーを継承しているため、トランスクリプト保存がオフになっています
</h3>

Claude Code は、生成するサブプロセスで [`CLAUDE_CODE_CHILD_SESSION`](/docs/ja/env-vars) を設定し、それを継承するインタラクティブセッションをネストされたものとして扱います：Claude Code はそのトランスクリプトを保存しないため、Claude 自体が開始するセッションは `--resume` リストを埋めません。この通知は、現在のセッションがマーカーを継承したことを意味します：

```text theme={null}
Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker · restart with CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1 to keep future transcripts
```

この通知は、別の Claude Code セッション内から `claude` を実行した場合に予想されます。マーカーが長寿命の仲介者（例えば、Claude Code セッションが元々開始したターミナル、`screen` セッション、またはランチャー）を通じてリークした場合、誤分類を示します。

tmux 内では、Claude Code は tmux サーバーのグローバル環境を通じて到達したマーカーを検出し、保存を続けるため、このケースではこの通知は表示されません。

**対応方法：**

* このセッションを別の Claude Code セッション内から意図的に開始した場合、アクションは不要です
* これがトップレベルセッションの場合、終了して [`CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1`](/docs/ja/env-vars) を設定して再起動します。保存は再起動から適用されるため、その前に送信されたメッセージは保存されません。
* 同じターミナルまたはランチャーからの将来の起動を修正するには、その環境から `CLAUDE_CODE_CHILD_SESSION` を削除します

<h2 id="configuration-warnings">
  設定警告
</h2>

Claude Code はこれらのメッセージのほとんどを stderr に書き込み、会話には書き込みません。また、ほとんどのメッセージはスタートアップ時に書き込みます。エントリは、デバッグログや会話ビューのスタートアップ通知など、別の場所に表示される場合、または [認識されないモデル診断行](#unrecognized-model-id-on-a-request) のようにリクエスト時など別の時間に表示される場合に、そのことを記載します。

<h3 id="exited-after-an-unrecoverable-interface-error">
  回復不可能なインターフェイスエラーの後に Claude Code が終了しました
</h3>

Claude Code は、ターミナルインターフェイスが回復できないエラーに遭遇して終了するときにこのメッセージを出力します。これはどちらのレンダラーでも発生する可能性があります。2 番目の文は、エラーが [フルスクリーン](/docs/ja/fullscreen) レンダラーの起動中に発生した場合にのみ表示されます。

```text theme={null}
Claude Code exited after an unrecoverable interface error (<error>). It happened while the fullscreen renderer was starting, so the next launch will use the classic renderer (CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1 forces that any time).
```

**対応方法：**

* Claude Code を再度起動してください。会話を再開するには、同じディレクトリで `claude --resume` を実行してください。
* メッセージがフルスクリーンレンダラーに言及している場合、[フルスクリーンレンダリング](/docs/ja/fullscreen#fullscreen-renderer-didnt-finish-starting) は次の起動が何を行うかを説明しており、これはフルスクリーンをどのように有効にしたかによって異なり、フルスクリーンを再度試すか、クラシックレンダラーを保持する方法が説明されています。

v2.1.236 より前では、Claude Code はこの種のエラーの後、メッセージを出力せずに終了していました。

<h3 id="agent-descriptions-are-over-the-15000-token-limit">
  エージェント説明が 15.0k トークン制限を超えています
</h3>

Claude Code はこの警告を stderr ではなく、会話ビューのスタートアップ通知として表示します。[サブエージェント](/docs/ja/sub-agents) の組み合わせた説明（組み込みのものを除く）が、Claude Code が推定する 15,000 トークンを超えています。各エージェントはその名前とその `description` フロントマターをカウントします。Claude Code は合計が制限を超えているかどうかに関わらず、すべてのエージェントを読み込むため、警告は何が読み込まれるかを変更しません。

```text theme={null}
Agent descriptions are over the 15.0k-token limit (~16.2k tokens) · ask Claude to trim agent descriptions in .claude/agents/
```

**対応方法：**

* エージェントファイルの `description` フロントマターを短縮するか、Claude に短縮するよう依頼してください。
* 使用しなくなったエージェントファイルを削除してください。

<h3 id="a-skill-command-or-workflow-wasnt-loaded-because-its-name-is-reserved">
  スキル、コマンド、またはワークフローが読み込まれませんでした。その名前は予約されています
</h3>

スキルフォルダ、フロントマター `name`、`.claude/commands/` 内のファイルまたはサブフォルダ、または [保存されたワークフロー](/docs/ja/workflows#save-the-workflow-for-reuse) が `anthropic-skills` という名前を使用するか、`anthropic-skills:` で始まる名前を使用しています。Claude Code は [claude.ai から同期されたスキルのためにその名前を予約](/docs/ja/skills#names-reserved-for-synced-skills) し、そのアイテムを読み込みません。

Claude Code はこの警告を stderr ではなく、会話ビューのスタートアップ通知として表示します。

```text theme={null}
Not loaded: rename .claude/skills/anthropic-skills, then restart — its name uses "anthropic-skills", a name reserved for the skills synced from your claude.ai account
```

通知は、拒否した最初のアイテムについて何を変更するかに名前を付けます。フォルダまたはファイルの名前を変更するか、`name:` 行を編集するか、ワークフローの名前を変更します。複数のアイテムが拒否された場合、通知は `· 2 more` などのカウントで終わり、[デバッグログ](/docs/ja/debug-your-config) は各アイテムに名前を付けます。

**対応方法：**

* 通知が名前を付けるアイテムの名前を変更するか、それが指す `name:` 行を編集し、セッションを再度起動してください。

v2.1.282 より前では、Claude Code はこれらの名前を持つスキルとコマンドを読み込みました。

<h3 id="workspace-has-not-been-trusted">
  ワークスペースが信頼されていません
</h3>

Claude Code はプロジェクトの `.claude/settings.json` または `.claude/settings.local.json` で `permissions.allow` ルールまたは `permissions.additionalDirectories` エントリを見つけましたが、[プロジェクト設定からの許可ルールはワークスペース信頼が必要](/docs/ja/permissions#project-allow-rules-and-workspace-trust) なため、それらを適用しませんでした。カウント、設定名、およびメッセージで名前が付けられたファイルは、設定によって異なります。`deny` および `ask` ルールは影響を受けません。

```text theme={null}
Ignoring 2 permissions.allow entries from .claude/settings.local.json: this workspace has not been trusted. Run Claude Code interactively here once and accept the trust dialog, or set projects["/Users/you/project"].hasTrustDialogAccepted: true in /Users/you/.claude.json.
```

**対応方法：**

* ディレクトリで `claude` を実行し、信頼ダイアログを受け入れてください。[プロジェクト許可ルールとワークスペース信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust) は、その受け入れがどのフォルダをカバーするかを説明しています。
* [非対話型モード](/docs/ja/headless) で `-p` を使用する場合、ダイアログは表示されません。メッセージが出力する正確な `projects` キーを使用して、`~/.claude.json` の `hasTrustDialogAccepted` エントリを設定してください。
* メッセージが `.claude/settings.local.json` に名前を付けており、git リポジトリの外またはホームディレクトリで Claude Code を起動した場合は、v2.1.200 以降に更新してください。バージョン 2.1.196 から 2.1.199 は、これらのワークスペースでは独自の `.claude/settings.local.json` をリポジトリ提供として扱いました。v2.1.207 以降では、git リポジトリの外で信頼ダイアログを受け入れていない場合、更新だけでは不十分です。フォルダがリポジトリ内にないことを判断するには git を実行する必要があり、Claude Code はその確認を信頼ダイアログを受け入れた後にのみ実行するため、最初のステップを使用してください。ホームディレクトリおよび他の [設定ホーム](/docs/ja/permissions#project-allow-rules-and-workspace-trust) は除外され、ダイアログを待ちません。[プロジェクト許可ルールとワークスペース信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust) を参照してください。

<h3 id="working-directory-is-a-network-path">
  作業ディレクトリはネットワークパスです
</h3>

Claude Code はネットワークパスを作業ディレクトリとして追加しません。ネットワークパスを検索すると、それが名前を付けるホストに接続でき、Windows ではその接続がホストに認証情報を送信する可能性があるため、Claude Code はそのパスを検索せずに拒否します。このメッセージは、そのようなパスで `/add-dir` を実行するとき、またはスタートアップ時の警告として表示されます。スタートアップ時に表示される場合、Claude Code はそのディレクトリなしで起動します。

```text theme={null}
\\server\share is a network path, which cannot be added as a working directory. On Windows, map the share to a drive letter and pass it at launch with --add-dir (a drive letter added mid-session does not yet carry remote-read trust).
```

Claude Code がこの方法で拒否するパスには、以下が含まれます。

* `\\server\share` などの UNC 共有
* `/net/<host>` などのオートマウントパス（そのホストのオートマウント下のディレクトリから Claude Code を起動した場合を除く）
* シンボリックリンクまたはジャンクションを通じてネットワークロケーションに到達するローカルパス

マップされたドライブ文字と `\\wsl$` パスはネットワークパスとしてカウントされません。

**対応方法：**

* Windows では、共有をドライブ文字にマップします。例えば `net use Z: \\server\share` を使用し、起動時に `claude --add-dir Z:\` でドライブを渡してください。
* macOS または Linux では、共有をローカルパスにマウントし、代わりにそのパスを追加してください。
* パスが `permissions.additionalDirectories` にある場合は、それをリストする設定ファイルから削除してください。

v2.1.257 より前では、Claude Code は到達可能なネットワークパスを作業ディレクトリとして受け入れていました。

<h3 id="remote-managed-settings-failed-to-load">
  リモート管理設定の読み込みに失敗しました
</h3>

セッションは [サーバー管理設定](/docs/ja/server-managed-settings) の対象ですが、Claude Code はそれらを取得できなかったか、サーバーが返したものを適用できなかったため、対話型セッションでこの警告を表示します。

括弧内の原因は、`network error`、`request timed out`、または `authentication rejected (401)` などの失敗した内容に名前を付けます。原因 `no setting in the server response could be applied as written` は、サーバーが応答したが、返された設定のいずれも [検証](/docs/ja/server-managed-settings#invalid-entries-in-delivered-settings) に合格しなかったことを意味します。v2.1.282 より前では、この原因は `server returned invalid settings` と読みました。

行の残りはセッションが実行するポリシーを示しています。

* **以前の成功した取得からキャッシュされた設定**：Claude Code は [保留されている環境変数](/docs/ja/server-managed-settings#fetch-and-caching-behavior) を除いて、そのキャッシュされたポリシーでセッションを実行し、行は `using cached policy` と読みます。
* **キャッシュなし**：Claude Code はサーバー管理設定なしでセッションを実行し、行は `no remote policy applied` と読みます。

**対応方法：**

* メッセージが名前を付ける原因に対応してください。ネットワーク原因の場合は、このマシンが `api.anthropic.com` に到達できることを確認してください。認証原因の場合は、`/status` でサインインを確認してください。
* `no setting in the server response could be applied as written` の場合は、管理者に、サーバー上の設定を修正するよう依頼してください。
* `/status` または `claude doctor` を実行して、完全な診断を取得してください。

v2.1.248 より前では、Claude Code は失敗した設定取得をデバッグログにのみ報告していました。

<h3 id="managed-settings-were-not-approved">
  管理設定が承認されませんでした
</h3>

組織の [サーバー管理設定](/docs/ja/server-managed-settings) には承認が必要な設定が含まれており、[セキュリティ承認ダイアログ](/docs/ja/server-managed-settings#security-approval-dialogs) を拒否したため、Claude Code はそれらを適用せずに終了します。

```text theme={null}
Managed settings were not approved; exiting without applying them.
```

**対応方法：**

* Claude Code を再度起動し、ダイアログを承認して、組織の設定の下で続行してください。拒否されたダイアログは記憶されないため、次の起動時に再度表示されます。
* ダイアログがリストする設定について不確かな場合は、承認する前に組織の管理設定を保守している人に確認してください。

<h3 id="managed-settings-block-the-default-model">
  管理設定がデフォルトモデルをブロックしています
</h3>

組織の [管理設定](/docs/ja/managed-settings) がデフォルトオプションが解決するモデルと、それがステップダウンできるすべてのモデルをブロックしています。デフォルトオプションで起動するセッションは、ブロックされたモデルを実行する代わりに、スタートアップで終了します。表示されるメッセージは、それをブロックする設定によって異なります。[`deniedModels`](/docs/ja/model-config#block-specific-models-or-versions) リストがそれをブロックする場合、メッセージは以下のように読みます。

```text theme={null}
Claude Code can't start: your organization's managed settings block the default model (claude-opus-5-5) in "deniedModels", and none of the models they allow can be used as the default instead. Ask your administrator to update "deniedModels" or "availableModels".
```

`availableModels` リストが [`availableModelsMatch`](/docs/ja/settings-reference#availablemodelsmatch) を `"exact"` に設定して省略する場合、メッセージは以下のように読みます。

```text theme={null}
Claude Code can't start: your organization allows only the models listed in "availableModels", and none of them can be used as the default model (claude-opus-5-5 isn't listed). Ask your administrator to update "availableModels".
```

**対応方法：**

* 設定を管理している場合は、ユーザーが実行できるモデルを `availableModels` に追加するか、すべてのフォールバックをブロックする `deniedModels` エントリを絞り込んでください。[特定のモデルまたはバージョンをブロック](/docs/ja/model-config#block-specific-models-or-versions) はデフォルトオプションがどのようにステップダウンするかを説明しています。
* 設定を管理していない場合は、メッセージを管理者に送信してください。独自の設定ファイルは、管理された `availableModels` または `deniedModels` リストを拡大することはできません。

<h3 id="managed-settings-dont-allow-this-api-provider">
  管理設定がこの API プロバイダーを許可していません
</h3>

組織の [管理設定](/docs/ja/managed-settings) は [`allowedProviders`](/docs/ja/settings-reference#allowedproviders) リストを設定し、セッションの API プロバイダーがそれにないか、セッションがそのエントリが要求する方法でピン留めされていないエンドポイントを使用しています。Claude Code はスタートアップ前、ログイン前、またはセッションが次に API に接続するときに拒否します。メッセージは許可されたプロバイダーで始まります。

```text theme={null}
Your organization's managed settings allow Claude Code to use: Anthropic API, Amazon Bedrock.
```

リストが空の場合、メッセージは代わりに以下のように読みます。

```text theme={null}
Your organization's managed settings allow Claude Code to use no API provider at all (allowedProviders is an empty list), so it cannot start on this machine.
```

すべてのエントリが認識されない場合、括弧内は `(allowedProviders lists only unrecognized entries)` と読みます。

**対応方法：**

* メッセージの `To continue:` ステップに従ってください。
* 設定を管理している場合、メッセージの `Admins:` で始まる行は、追加するエントリまたはピン留めする値に名前を付け、[`allowedProviders`](/docs/ja/settings-reference#allowedproviders) エントリは、どのソースの `env` ブロックがそれをピン留めできるかを示しています。

<h3 id="mcp-server-is-blocked-by-enterprise-managed-policy">
  MCP サーバーはエンタープライズ管理ポリシーによってブロックされています
</h3>

`/mcp` でサーバーの **再接続** を選択したか、無効なサーバーをそこで再度有効にしたところ、[MCP サーバーを制限する](/docs/ja/managed-mcp) 設定がそのサーバーをブロックしています。Claude Code はそれへの接続を拒否し、以下を表示します。

```text theme={null}
MCP server <name> is blocked by enterprise managed policy
```

これらの設定のいずれかがメッセージを生成できます。

* サーバーに一致する [`deniedMcpServers`](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists) エントリ（`~/.claude/settings.json` またはプロジェクトの `.claude/settings.json` のものを含む）
* サーバーが一致しない [`allowedMcpServers`](/docs/ja/managed-mcp#policy-based-control-with-allowlists-and-denylists) リスト
* [`strictPluginOnlyCustomization`](/docs/ja/settings-reference#strictpluginonlycustomization) と `mcp` ロック（`~/.claude.json` および `.mcp.json` で設定されたサーバーをブロック）
* [`disableClaudeAiConnectors`](/docs/ja/mcp#disable-claude-ai-connectors)（サーバーが claude.ai コネクタの場合）

**対応方法：**

* 独自のユーザーおよびプロジェクト設定ファイルでこれらの設定のいずれかを確認し、変更または削除してください。
* 独自の設定がブロックを説明しない場合は、管理者に、どの管理設定がサーバーをブロックするかを確認してください。

v2.1.257 より前では、`/mcp` での **再接続** と再度有効化は、セッション中のポリシー更新がブロックしたサーバーに接続できました。

<h3 id="managed-settings-document-could-not-be-parsed">
  管理設定ドキュメントを解析できませんでした
</h3>

組織は [管理設定](/docs/ja/managed-settings) をデプロイしており、デプロイされたドキュメントの 1 つが存在しますが、JSON オブジェクトとして解析できないため、Claude Code はポリシーを実行せずにスタートアップ時に終了コード 1 で終了します。行は失敗したソースをメッセージの前に名前を付けます。

```text theme={null}
/Library/Application Support/ClaudeCode/managed-settings.json: Managed settings document could not be parsed as a JSON object; none of its settings are in effect. Fix or remove it.
```

ソースは以下のいずれかです。

* `managed-settings.json` ファイルのパスまたは `managed-settings.d` 下のドロップインファイル
* macOS 管理設定プロファイル、`ユーザーごとの管理設定` または `デバイスレベルの管理設定`
* Windows レジストリ値、`Registry: HKLM\SOFTWARE\Policies\ClaudeCode\Settings`

[Claude Code がドロップしたエントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、各ソースを解析不可能にするものをリストしています。

Claude Code は、別の管理ソースが有効なポリシーを配信する場合でも、起動を拒否します。このエラーは対話型セッション、`claude -p`、Agent SDK セッション、[バックグラウンドセッション](/docs/ja/agent-view)、およびほとんどのサブコマンド（`claude doctor` を含む）で表示されます。拒否は意図的に閉じられます。Claude Code が解析できないドキュメント内の設定は強制できず、とにかく起動すると、組織の制御なしでセッションが実行されます。

解析可能なドキュメント内のスキーマ問題はこのエラーを生成しません。[Claude Code がドロップしたエントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、Claude Code が 1 つで何を行うかをカバーしています。

`managed-settings.d/` ディレクトリが存在しますが、リストできない場合、Claude Code は `Managed settings drop-in directory could not be read:` の後に基になるエラーを報告します。[Claude Code がドロップしたエントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、読み取り失敗がスタートアップで終了する場合をカバーしています。

**対応方法：**

* マシンを管理している場合は、名前が付けられたドキュメントを JSON オブジェクトとして解析するように修正するか、ファイル、プロファイル、またはレジストリ値を削除してください。空の `managed-settings.json` は `{}` としてカウントされ、起動をブロックしません。
* そうでない場合は、管理者に、デプロイされたドキュメントを修正するよう依頼してください。独自の設定ファイルの何もこのエラーを引き起こしたり、クリアしたりしません。

<h3 id="unable-to-read-managed-policy-settings">
  管理ポリシー設定を読み取ることができません
</h3>

組織は [管理設定](/docs/ja/managed-settings) をデプロイしており、デプロイされたソースの 1 つが存在しますが、オペレーティングシステムが読み取りを拒否するのではなく、I/O エラーなどの理由で読み取ることができませんでした。他の管理ソースがポリシーを供給していない場合、Claude Code はポリシーが実行される可能性があるソースなしで実行するのではなく、スタートアップで終了します。

```text theme={null}
Unable to read managed policy settings.
This machine may require organization login enforcement, but the policy file failed to load.
Contact your administrator.

Detail: <source>: <reason>
```

同じ状態で、サインインフロー、既に実行中のセッションからの API リクエスト、および [`claude gateway`](/docs/ja/claude-apps-gateway) サーバーは、[`allowedProviders`](/docs/ja/settings-reference#allowedproviders) に名前を付ける最初の行のバリアントで拒否されます。

オペレーティングシステムが拒否した読み取り（ルートのみのファイルなど）はこの終了を生成しません。[セッションはそのソースのポリシーなしで開始します](/docs/ja/managed-settings#find-entries-claude-code-dropped)。解析できないソースの場合、Claude Code は [ソースに名前を付ける別のメッセージで終了します](#managed-settings-document-could-not-be-parsed)。

**対応方法：**

* マシンを管理している場合は、`Detail:` 行が名前を付ける問題を修正して、デプロイされたソースを読み取ることができるようにするか、ソースを削除してください。
* そうでない場合は、メッセージを管理者に送信してください。独自の設定ファイルの何もこのエラーを引き起こしたり、クリアしたりしません。

v2.1.285 より前では、claude.ai または Claude Console 認証情報でサインインしたセッションのみがこのメッセージで終了し、オペレーティングシステムが拒否した読み取りもそれを生成していました。

<h3 id="otelheadershelper-failed">
  otelHeadersHelper が失敗しました
</h3>

Claude Code は、[`otelHeadersHelper`](/docs/ja/settings-reference#otelheadershelper) スクリプトが失敗したか、[スクリプト要件](/docs/ja/monitoring-usage#script-requirements) を満たさない出力を出力したときに、この警告を対話型セッションで通知として表示します。

スクリプトが失敗し続ける間、エクスポートは失敗し、テレメトリバックエンドはセッションから何も受け取りません。

`See /status:` の後のテキストは、スクリプトの終了コードとそのエラー出力など、失敗した内容を示しています。

```text theme={null}
otelHeadersHelper failed; telemetry is not being exported. See /status: exited 1: token service unreachable
```

**対応方法：**

* `/status` を実行して、失敗の詳細を読んでください。
* スクリプトが 30 秒以内に終了コード 0 で終了し、stdout に文字列ヘッダー値の JSON オブジェクトを出力するように修正してください。[スクリプト要件](/docs/ja/monitoring-usage#script-requirements) を参照してください。
* 組織が [管理設定](/docs/ja/managed-settings) を通じてスクリプトをデプロイしている場合は、それを保守している人にそれを修正するよう依頼してください。

[非対話型モード](/docs/ja/headless) で `-p` を使用する場合、同じ失敗は stderr に `otelHeadersHelper failed (OpenTelemetry export headers unavailable): <error>` として表示されます。

<h3 id="headershelper-not-run">
  headersHelper が実行されていません
</h3>

Claude Code は MCP サーバーを静的 `headers` だけで接続し、サーバーの [`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) をスキップしました。これは、ヘルパーがシェルコマンドであり、フォルダに保存された信頼がないためです。フォルダは、`~/.claude.json` でそのエントリを手動で設定するか、ホームディレクトリの外で、対話型セッションでそれを受け入れるときに、保存された信頼を取得します。[headersHelper を実行する前にフォルダを信頼する](/docs/ja/mcp#trust-a-folder-before-its-headershelper-runs) を参照して、このチェックが適用されるサーバーを確認してください。

Claude Code は [非対話型モード](/docs/ja/headless) でのみこの行を書き込み、サーバーごとに 1 回です。対話型セッションでは、同じ拒否をデバッグログに書き込みます。

```text theme={null}
MCP server 'internal-api': headersHelper not run — this workspace has no persisted trust; accept the trust dialog here once interactively, or set projects["/Users/you/project"].hasTrustDialogAccepted in /Users/you/.claude.json.
```

メッセージが出力する `projects` キーは、[プロジェクト許可ルールとワークスペース信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust) が Claude Code がその信頼をキーにするフォルダです。親フォルダの信頼ダイアログを受け入れることはこのチェックを満たさず、`-p` または SDK セッションもそれを満たしません。

**対応方法：**

* メッセージが名前を付けるフォルダで `claude` を実行し、信頼ダイアログを受け入れ、その後、`-p` または SDK コマンドを再度実行してください。
* `~/.claude.json` で `hasTrustDialogAccepted` エントリを自分で設定し、メッセージが出力する正確な `projects` キーを使用してください。
* ホームディレクトリでセッションを開始した場合は、信頼したプロジェクトディレクトリから作業してください。ホームディレクトリで信頼ダイアログを受け入れると、Claude Code はその信頼を現在のセッションのみ保持します。

<h3 id="malformed-tool-content-rule">
  不正な形式の Tool(content) ルール
</h3>

[権限ルール](/docs/ja/permissions#permission-rule-syntax) の 1 つが設定ファイルに `Tool` または `Tool(content)` の形状を持たない場合（例えば、テキストが閉じ括弧の後に続く、または括弧の 1 つが欠落している）。Claude Code はルールをスキップし、対話型セッションが開始されるときに無効な設定ダイアログにリストし、[`claude doctor`](/docs/ja/debug-your-config#check-resolved-settings) 出力に表示します。

```text theme={null}
Invalid permission rule "Bash(ls) x" was skipped: Malformed Tool(content) rule. Rules take the form Tool or Tool(content) and must end at the closing ")"; parentheses inside the content are literal
```

**対応方法：**

* メッセージでリストされた設定ファイルで、ルールを閉じ括弧で終わるように書き直してください。例えば、`Bash(ls) x` の代わりに `Bash(ls *)` を使用してください。
* コンテンツ内の括弧はそのままにしてください。それらはリテラルなので、`Edit(./Finance (2024)/**)` などのルールはエスケープなしで有効です。

v2.1.260 より前では、Claude Code は一致しない括弧を持つルールを `Mismatched parentheses` として報告していました。

<h3 id="is-not-matched-by-file-permission-checks">
  ファイル権限チェックと一致しません
</h3>

Claude Code は、[設定ファイル](/docs/ja/settings#where-settings-live)、[管理設定](/docs/ja/managed-settings)、または `--allowedTools`、`--disallowedTools`、または `--settings` フラグ値で、`Write`、`NotebookEdit`、`MultiEdit`、または `Glob` [権限ルール](/docs/ja/permissions#read-and-edit) を持つパスを見つけました。ファイル権限を `Edit` および `Read` ルールに対してのみチェックするため、他のファイルツールのいずれかに名前を付けるパスルールを参照することはありません。ルールを保持し、他に何も変更しません。警告はルール、括弧内のソース、および書き込む置換に名前を付けます。

```text theme={null}
Permission deny rule (.claude/settings.json): Write(docs/**) is not matched by file permission checks — only Edit(path) rules are. Use Edit(docs/**) instead (Edit rules cover all file-editing tools).
```

**対応方法：**

* `Write(path)`、`NotebookEdit(path)`、および従来の `MultiEdit(path)` ルールを `Edit(path)` に置き換えてください。`Edit` ルールはすべてのファイル編集ツールをカバーしています。
* `--allowedTools` を除き、Claude Code は警告なしで `Glob` ルールを受け入れます。`Glob(path)` ルールを `Read(path)` に置き換えてください。
* 警告が括弧内に名前を付けるソースでルールを修正してください。設定ファイルパス、または `--allowed-tools` および `--disallowed-tools` フラグ自体。ディスク上に存在しない `claude-settings-<hash>.json` パスはインライン `--settings` 値を表します。そのフラグに渡す JSON を修正してください。
* `Write` または `Glob` などのベアツール名ルールはそのままにしてください。Claude Code は [ツールレベル](/docs/ja/permissions#match-all-uses-of-a-tool) でそれらと一致し、それらについて警告しません。
* ソースが `managed policy settings` と読む場合は、警告を管理設定を保守している人に転送してください。自分でそれをクリアすることはできません。

[バックグラウンドセッション](/docs/ja/agent-view) または `--output-format json` または `stream-json` では、Claude Code は警告をデバッグログに stderr の代わりに書き込むため、マシン読み取り出力はクリーンなままです。`--debug` で `~/.claude/debug/<session-id>.txt` でキャプチャしてください。v2.1.210 より前では、Claude Code はこれらのルールを警告なしで受け入れていました。

<h3 id="has-a-wildcard-before-the-rest-of-the-command">
  コマンドの残りの部分の前にワイルドカードがあります
</h3>

Claude Code は、`*` が後の単語の前に来る `Bash` 許可ルールを見つけました。その単語はどのコマンドであるかを決定します。例えば `Bash(git * main)` または `Bash(git -C * status *)`。これは [設定ファイル](/docs/ja/settings#where-settings-live)、[管理設定](/docs/ja/managed-settings)、または `--allowedTools` または `--settings` フラグ値のいずれかにあります。`*` はテキストを一致させます。その位置に挿入されたオプションを含みます。`Bash(git * main)` は `git -c core.fsmonitor=<script> diff main` も承認します。ここで `-c` は git にコマンドが名前を付けるプログラムを実行させます。[ワイルドカードパターン](/docs/ja/permissions#wildcard-patterns) は一致ルールを示しています。

警告は、意図したより広いワイルドカードを持つルールを絞り込むことができるように存在します。Claude Code はルールを保持し、それがどのように一致するかについて何も変更しません。警告はルールとその括弧内のソースに名前を付けます。

```text theme={null}
Permission allow rule (.claude/settings.json): Bash(git -C * status *) has a wildcard before the rest of the command, so it also matches any options inserted at that position and approves them without a prompt. For git, options such as -c and --exec-path can run arbitrary commands. Replace that * with the exact value you mean, or only use * after the subcommand (for example Bash(git status *)).
```

**対応方法：**

* サブコマンドの前の `*` を意味する正確な値に置き換えてください。`Bash(git * main)` の代わりに `Bash(git checkout main)` を使用してください。
* すべての `*` をサブコマンドの後に移動してください。`Bash(git -C * status *)` の代わりに `Bash(git status *)` を使用してください。許可したいサブコマンドごとに 1 つのルールを書いてください。
* 警告が括弧内に名前を付けるソースでルールを修正してください。設定ファイルパス、または `--allowed-tools` フラグ自体。ディスク上に存在しない `claude-settings-<hash>.json` パスはインライン `--settings` 値を表します。そのフラグに渡す JSON を修正してください。
* ソースが `managed policy settings` と読む場合は、警告を管理設定を保守している人に転送してください。自分でそれをクリアすることはできません。

[バックグラウンドセッション](/docs/ja/agent-view) または `--output-format json` または `stream-json` では、Claude Code は警告をデバッグログに stderr の代わりに書き込むため、マシン読み取り出力はクリーンなままです。`--debug` で `~/.claude/debug/<session-id>.txt` でキャプチャしてください。v2.1.246 より前では、Claude Code はこれらのルールを警告なしで受け入れていました。

<h3 id="denying-bash-also-turns-off-the-powershell-tool">
  Denying Bash also turns off the PowerShell tool
</h3>

Bash ツール全体を削除しました。例えば `--disallowedTools Bash` を使用したか、設定ファイルのいずれかで単独の `Bash` または `Bash(*)` [拒否ルール](/docs/ja/permissions#match-all-uses-of-a-tool) を設定した場合です。Git Bash がインストールされた Windows では、[Bash を拒否すると PowerShell ツールもオフになる](/docs/ja/tools-reference#bash-deny-rules-also-turn-off-the-powershell-tool) ため、セッションはシェルツールなしで起動します。Claude Code はスタートアップ時にこの警告を出力します。

```text theme={null}
Denying Bash also turns off the PowerShell tool, so Claude has neither. To use PowerShell, set CLAUDE_CODE_USE_POWERSHELL_TOOL=1.
```

**対応方法：**

* Claude に PowerShell を使用させるには、[PowerShell ツールを有効にする](/docs/ja/tools-reference#enable-the-powershell-tool) で示されているように、環境または設定ファイルの `env` ブロックで [`CLAUDE_CODE_USE_POWERSHELL_TOOL`](/docs/ja/env-vars) を `1` に設定してください。これにより、Bash 拒否ルールと並行して PowerShell ツールがオンのままになります。
* ツール全体ではなく特定のコマンドをブロックするには、同じ設定ファイルまたはフラグ内の単独の `Bash` エントリを、`Bash(git push *)` などのスコープ付きルールに置き換えてください。Claude は Bash ツールを保持し、PowerShell ツールは、変数も設定するかスコープ付きの [`PowerShell` 権限ルール](/docs/ja/permissions#powershell) を追加するまでオフのままです。

[バックグラウンドセッション](/docs/ja/agent-view) または `--output-format json` または `stream-json` では、Claude Code は警告を stderr の代わりにデバッグログに書き込みます。`--debug` で実行すると `~/.claude/debug/<session-id>.txt` にキャプチャできます。v2.1.287 より前では、Claude Code は警告を出力せずに同じ方法で PowerShell ツールをオフにしていました。

<h3 id="crosssessioninbound-must-be-one-of-accept-hold-refuse">
  crossSessionInbound は accept、hold、refuse のいずれかである必要があります
</h3>

設定ファイルは [`crossSessionInbound`](/docs/ja/settings-reference#crosssessioninbound) を Claude Code が認識しない値に設定します。例えば、タイプミスの `"reject"`。警告の 2 番目の文は、どのファイルが値を保持するかによって異なります。ユーザー、プロジェクト、ローカル、または `--settings` ファイルでは、以下のように読みます。

```text theme={null}
"crossSessionInbound" must be one of "accept", "hold", "refuse"; received "reject". This value was ignored; while it is present, cross-session messages are held for your approval instead of being delivered. Set it to one of the values above.
```

[管理設定](/docs/ja/managed-settings) では、Claude Code は認識されない値を `refuse`（最も制限的な値）として扱い、警告は、管理者がそれを修正するまで、クロスセッションメッセージが拒否されることを示しています。保留が他の設定ファイルの値とどのように組み合わされるかについては、[`crossSessionInbound`](/docs/ja/settings-reference#crosssessioninbound) を参照してください。

**対応方法：**

* キーを `"accept"`、`"hold"`、または `"refuse"` に設定するか、削除してください。
* 警告が管理設定に名前を付ける場合は、管理者に値を修正するよう依頼してください。

v2.1.248 より前では、Claude Code は認識されない値を警告なしで無視していました。

<h3 id="anthropic-foundry-resource-must-be-a-foundry-resource-name">
  ANTHROPIC\_FOUNDRY\_RESOURCE は Foundry リソース名である必要があります
</h3>

[`ANTHROPIC_FOUNDRY_RESOURCE`](/docs/ja/env-vars) を、エンドポイント URL やそのホスト名など、単独の [Microsoft Foundry](/docs/ja/microsoft-foundry) リソース名以外のものに設定しました。Claude Code はリクエストを送信する前にその値を拒否しました。このメッセージはスタートアップ警告としてではなく、Claude の応答の代わりに表示されます。

```text theme={null}
API Error: ANTHROPIC_FOUNDRY_RESOURCE must be a Foundry resource name (2-64 letters, digits and hyphens, not starting or ending with a hyphen, such as my-resource), not a URL or host name. To use a full URL, set ANTHROPIC_FOUNDRY_BASE_URL instead.
```

**対応方法：**

* `ANTHROPIC_FOUNDRY_RESOURCE` をリソース名のみに設定し、Claude Code を再起動してください。エンドポイント `https://my-resource.services.ai.azure.com/anthropic` の場合、名前は `my-resource` です。
* 代わりに完全なエンドポイント URL を指定するには、[`ANTHROPIC_FOUNDRY_BASE_URL`](/docs/ja/env-vars) にその URL を設定して `ANTHROPIC_FOUNDRY_RESOURCE` を削除し、Claude Code を再起動してください。Claude Code は 2 つの変数のうち 1 つのみを受け入れます。

<h3 id="the-200k-limit-isnt-enforced">
  200K 制限は強制されていません
</h3>

[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/docs/ja/env-vars) を設定しました。これは通常、[自動コンパクション](/docs/ja/model-config#default-auto-compact-thresholds) が 1M コンテキストモデルのセッションを 200K ウィンドウに保持しますが、コンパクションしきい値がこのセッションを 200K 以下で上限にしないため、会話はそれを超えて成長できます。

```text theme={null}
CLAUDE_CODE_DISABLE_1M_CONTEXT is set, but the 200K limit isn't enforced for <model>, so this session can grow past it. To enforce it, set CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000 (or the autoCompactWindow setting).
```

Claude Code は、ネイティブ 1M ウィンドウを持つと認識するすべてのモデルに対して、および認識しないモデル ID に対して、それが想定するウィンドウでコンパクトするため、200K 制限を独自に強制します。警告は、他の設定がその強制を破る場合に表示されます。

* モデル ID は Claude Code が認識しないもの（[LLM ゲートウェイ](/docs/ja/llm-gateway) エイリアスなど）であり、[`CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1`](/docs/ja/env-vars) を設定したか、[`CLAUDE_CODE_MAX_CONTEXT_TOKENS`](/docs/ja/env-vars) で想定ウィンドウを 200K を超えて上げました。この場合、メッセージは `or update to a Claude Code version that recognizes <model>` も提供します。
* `context-1m` ベータは [`ANTHROPIC_BETAS`](/docs/ja/env-vars) または [`--betas`](/docs/ja/cli-reference#cli-flags) フラグを通じてリクエストされ、そのベータを受け入れるモデルで API に 1M ウィンドウを要求し続けますが、何もセッションを 200K でコンパクトしません。

**対応方法：**

* [`CLAUDE_CODE_AUTO_COMPACT_WINDOW=200000`](/docs/ja/env-vars) を設定するか、[`autoCompactWindow`](/docs/ja/settings-reference#autocompactwindow) 設定を `200000` に設定して、自動コンパクションが 200K 境界でコンパクトするようにしてください。
* メッセージがこのバージョンが認識しないモデル ID に名前を付ける場合は、`claude update` を実行してください。ID を 1M コンテキストモデルとして認識するバージョンは、さらなる設定なしで制限を強制します。
* セッションがモデルの完全なウィンドウを代わりに使用したい場合は、`CLAUDE_CODE_DISABLE_1M_CONTEXT` を設定解除してください。警告は 200K 制限が強制されていないことのみを報告します。

[バックグラウンドセッション](/docs/ja/agent-view) または `--output-format json` または `stream-json` では、Claude Code は警告をデバッグログに stderr の代わりに書き込みます。

<h3 id="unrecognized-model-id-on-a-request">
  リクエストで認識されないモデル ID
</h3>

Claude Code は、Claude Code バージョンが認識しないモデル ID のリクエストを送信し、そのモデル ID を認識するモデルにマップする [`modelOverrides`](/docs/ja/model-config#override-model-ids-per-version) エントリを見つけませんでした。Claude Code は依然としてそのように設定した ID でリクエストを送信し、終了またはモデルを切り替えません。

```text theme={null}
[claude-code:unrecognized_model] {"model":"my-proxy-model","query_source":"sdk"}
```

stderr を読み取るスクリプトまたはハーネスでは、`[claude-code:unrecognized_model]` プレフィックスと一致します。プレフィックスと 1 つのスペースの後、Claude Code は 1 行の JSON オブジェクトを書き込みます。Claude Code は後のバージョンでそれにフィールドを追加できるため、予期しないフィールドを無視してください。少なくともこれら 2 つを書き込みます。

* `model`：設定したモデル文字列
* `query_source`：モデルを使用したリクエストパス。Claude Code は `-p` 実行に対して `sdk` を報告し、サブエージェントに対して `agent:` で始まる値を報告します。

Claude Code は、実行方法に応じて、2 つの場所のいずれかに行を書き込みます。

* [非対話型モード](/docs/ja/headless) で `-p` を使用する場合、Claude Code はすべての `--output-format` の下で stderr に書き込むため、行をフィルタリングせずに stdout を解析できます。
* 対話型セッションまたは [バックグラウンドセッション](/docs/ja/agent-view) では、Claude Code は代わりにデバッグログに書き込みます。`--debug` で `~/.claude/debug/<session-id>.txt` でキャプチャしてください。

Claude Code は、プロセスごとにモデル文字列ごとに 1 回、行を書き込みます。[サブエージェント](/docs/ja/sub-agents#choose-a-model) または [バックグラウンド機能](/docs/ja/costs#background-token-usage) が使用するものなど、さらに認識されない ID ごとに別の行を書き込みます。

Claude Code は、Amazon Bedrock `us.anthropic.claude-...` ID、Google Cloud の Agent Platform ID（`@` バージョンサフィックス付き）、Claude モデル ID を含む Microsoft Foundry デプロイメント名など、認識するモデルに解決するプロバイダー ID の行を書き込みません。Claude Code は、ARN 自体ではなく、Amazon Bedrock [アプリケーション推論プロファイル ARN](/docs/ja/amazon-bedrock#map-each-model-version-to-an-inference-profile) の背後にあるモデルをチェックします。解決できない ARN（タイプミスされたものなど）に対して行を書き込みません。

**対応方法：**

* ID を意図的に設定した場合（[LLM ゲートウェイ](/docs/ja/llm-gateway) エイリアスなど）、[設定ファイル](/docs/ja/settings#where-settings-live) に [`modelOverrides`](/docs/ja/model-config#override-model-ids-per-version) エントリを追加し、ID をその値として使用してください。キーとして Anthropic モデル ID を使用し、`opus` などのファミリエイリアスは使用しないでください。例の行の `my-proxy-model` の場合、このエントリを追加してください。

  ```json theme={null}
  {
    "modelOverrides": {
      "claude-opus-4-6": "my-proxy-model"
    }
  }
  ```

  Claude Code は `my-proxy-model` を `claude-opus-4-6` として扱い、行の書き込みを停止します。

* ID が Claude Code バージョンより新しいモデルに名前を付ける場合は、`claude update` を実行してください。

* ID がタイプミスの場合は、[モデルを設定できる場所](/docs/ja/model-config#setting-your-model) または [エイリアス変数](/docs/ja/model-config#environment-variables) のいずれかで保持する場所で修正してください。`query_source` が `agent:` で始まる場合は、代わりに [サブエージェントのモデル](/docs/ja/sub-agents#choose-a-model) を設定する場所で修正してください。

v2.1.233 より前では、Claude Code は認識しないモデル ID のリクエストを送信したときに行を書き込みませんでした。

<h3 id="stale-sandbox-mask-files-left-by-a-killed-session">
  殺されたセッションによって残された古いサンドボックスマスクファイル
</h3>

`claude doctor` はその診断でこの警告を出力し、`/status` は同じ行をリストします。これは、[サンドボックス](/docs/ja/sandboxing) がファイルシステム分離をオンにして有効になっている Linux および WSL2 に表示されます。

サンドボックスコマンドが実行されている間、サンドボックスはまだ存在しないファイルへの書き込み拒否を保持し、そこに 0 バイトの読み取り専用プレースホルダーを作成し、その後削除します。SIGKILL によって殺されたセッションなど、そのクリーンアップが実行される前に、プレースホルダーが残ります。後のセッションは、起動するたびにそれらを読み取り専用で再度バインドするため、「はい、今後は尋ねない」を保存するなどの設定書き込みは、そこに座っているものが失敗します。

```text theme={null}
- Stale sandbox mask files left by a killed session: /home/you/project/.claude/settings.local.json
  Fix: Remove each with `rm <path>` while no other Claude Code session is running in that project — a 0-byte read-only file where a settings file belongs makes "Yes, and don't ask again" fail to save, and the sandbox binds it read-only again on every start
```

**対応方法：**

* そのプロジェクトで実行されている他の Claude Code セッションを終了し、`rm` で各リストされたファイルを削除してください。警告は最大 3 つのファイルに名前を付け、残りをカウントするため、削除されるまで `claude doctor` を再度実行してください。別のセッションのサンドボックスがまだ使用しているプレースホルダーは、そのセッションの書き込み保護の生きた部分です。
* 「はい、今後は尋ねない」で保存した権限の選択が固定されなかった場合は、プレースホルダーを削除した後、再度保存してください。

v2.1.257 より前では、`claude doctor` はこれらのファイルにフラグを立てませんでした。以前のバージョンは、セッションが殺されたときに同じプレースホルダーを残します。

<h2 id="responses-seem-lower-quality-than-usual">
  応答の品質がいつもより低いように見える
</h2>

Claude の回答がいつもより能力が低いように見えるが、エラーが表示されていない場合、原因は通常、モデル自体ではなく会話の状態です。Claude Code はモデルバージョンを静かに変更することはありません。これらのケースでフォールバックモデルに切り替わることができます。

* 設定された [`--fallback-model`](/docs/ja/cli-reference#cli-flags) は可用性エラーの後、そのターンのみ引き継ぎ、トランスクリプトに通知が表示されます
* Amazon Bedrock または Google Cloud の Agent Platform スタートアップチェックがデフォルトモデルが利用不可であることを検出するか、アカウントが [セッション中にそれへのアクセスを失う](/docs/ja/amazon-bedrock#when-a-model-is-disabled-mid-session)
* [自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback) は Fable 5.1、Fable 5、Opus 5.5、Sonnet 5.5、Opus 5 でセッションをフラグが付いたカテゴリのフォールバックモデルに移動し、そのカテゴリにフォールバックモデルがある場合、トランスクリプトに通知が表示されます

以下のモデル選択チェックは 2 番目と 3 番目のケースをキャッチします。最初のケースはトランスクリプト通知として表示され、`/model` の変更ではなく表示されます。[モデル設定](/docs/ja/model-config) は各フォールバックが適用される時期を説明しています。

まずこれらを確認してください。

* **モデル選択**: `/model` を実行して、期待するモデルにいることを確認します。以前の `/model` の選択または `ANTHROPIC_MODEL` 環境変数により、意図したより小さいモデルにいる可能性があります。
* **努力レベル**: `/effort` を実行して現在の推論レベルを確認し、難しいデバッグまたは設計作業のためにそれを上げます。デフォルトはモデルによって異なるため、最大値以下であると仮定する前に確認してください。[努力レベルを調整する](/docs/ja/model-config#adjust-effort-level) でモデルごとのデフォルトと `ultrathink` ショートカットを参照してください。
* **コンテキスト圧力**: `/context` を実行してウィンドウがどの程度満杯かを確認します。容量に近い場合は、自然な区切り点で `/compact` を実行するか、`/clear` を実行して新しく開始します。[コンテキストウィンドウを探索する](/docs/ja/context-window) で auto-compact が以前のターンにどのように影響するかを参照してください。
* **古い指示**: 大きいまたは古い `CLAUDE.md` ファイルと MCP ツール定義はコンテキストを消費し、応答を操作できます。`/doctor` チェックアップは過度に大きいメモリファイルと未使用の拡張機能にフラグを付け、`/context` は MCP ツールトークン使用量を表示します。v2.1.205 より前では、`/doctor` は過度に大きいメモリファイルとサブエージェント定義にフラグを付けた診断画面を開きました。

応答がうまくいかない場合、通常は修正で返信するよりも巻き戻す方が効果的です。Esc を 2 回押すか `/rewind` を実行して悪いターンの前に戻り、より具体的なプロンプトで言い換えます。スレッド内で修正すると、間違った試みがコンテキストに残り、後の回答をそれに固定する可能性があります。[チェックポイント](/docs/ja/checkpointing) を参照してください。

上記を確認した後も品質がまだおかしいように見える場合は、`/feedback` を実行して、期待したものと得たものを説明してください。この方法で送信されたフィードバックには会話トランスクリプトが含まれており、Anthropic が実際の回帰を診断する最速の方法です。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。

Claude が疑わしいプロンプトインジェクションについて警告する場合、または疑わしいインジェクションのためにリクエストを拒否する場合、警告が名前を付けるテキストがファイルまたは Web コンテンツではなく Claude Code が会話に自動的に追加するコンテキストである場合は、`claude update` を実行して再試行してください。更新後に警告が繰り返される場合は、フラグが付いたコンテンツをプロンプトに貼り付け直すのではなく、[報告してください](#report-an-error)。v2.1.201 より前では、Sonnet 5 は同じ方法でいくつかのリクエストを拒否しました。

<h2 id="report-an-error">
  エラーを報告する
</h2>

このページで扱っていないコンポーネントからのエラーについては、関連するガイドを参照してください。

* MCP サーバーが接続または認証に失敗した場合：[MCP](/docs/ja/mcp)
* Hook スクリプトが失敗したか、ツールをブロックした場合：[Debug hooks](/docs/ja/hooks#debug-hooks)
* インストール中に権限が拒否されたか、ファイルシステムエラーが発生した場合：[Troubleshoot installation and login](/docs/ja/troubleshoot-install)

ここにエラーが記載されていない場合、または提案された修正が役に立たない場合：

* Claude Code 内で `/feedback` を実行して、トランスクリプトと説明を Anthropic に送信します。このコマンドは、事前入力された GitHub issue を開くオプションも提供します。Anthropic への送信には[認証](/docs/ja/authentication)が必要です。Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、その他のサードパーティプロバイダー、または Anthropic 認証情報が設定されていない場合、`/feedback` は代わりに Anthropic アカウント担当者に送信できるローカルアーカイブを保存します。
* シェルから `claude doctor` を実行して、インストールの読み取り専用診断を実行するか、Claude Code 内で `/doctor` チェックアップを実行してセットアップの問題を検出して修正します。
* [status.claude.com](https://status.claude.com) でアクティブなインシデントを確認します。
* GitHub の[既存の issue](https://github.com/anthropics/claude-code/issues) を検索します。
