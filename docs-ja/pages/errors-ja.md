> ## Documentation Index
> Fetch the complete documentation index at: https://code.claude.com/docs/llms.txt
> Use this file to discover all available pages before exploring further.

# エラーリファレンス

> Claude Code のランタイムエラーメッセージを検索し、各エラーの意味と修正方法を確認できます。

このページでは、Claude Code が表示するランタイムエラーと各エラーからの復旧方法、および応答がエラーなしで問題があるように見える場合に確認すべき内容を一覧表示しています。セットアップ中の `command not found` や TLS エラーなどのインストールエラーについては、[インストールとログインのトラブルシューティング](/docs/ja/troubleshoot-install)を参照してください。

[ラッパーと IDE エラー](#wrapper-and-ide-errors)を除き、これらのエラーと復旧コマンドは CLI、[Desktop アプリ](/docs/ja/desktop)、および [Claude Code on the web](/docs/ja/claude-code-on-the-web)全体に適用されます。これら 3 つはすべて同じ Claude Code CLI をラップしているためです。その他の表面固有の問題については、その表面のページのトラブルシューティングセクションを参照してください。

<Note>
  Claude Code は Claude API を呼び出してモデルレスポンスを取得するため、ほとんどのランタイムエラーは基盤となる API エラーコードにマップされます。このページでは、Claude Code 内での各エラーの意味と復旧方法について説明しています。生の HTTP ステータスコード定義については、[Claude Platform エラーリファレンス](https://platform.claude.com/docs/en/api/errors)を参照してください。
</Note>

<h2 id="find-your-error">
  エラーを見つける
</h2>

以下のセクションに表示されるメッセージを照合してください。

| メッセージ                                                                                                                                                                                                 | セクション                                                                                             |
| :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------ |
| `API Error: 500 Internal server error`                                                                                                                                                                | [サーバーエラー](#api-error-500-internal-server-error)                                                   |
| `API Error: Repeated 529 Overloaded errors`                                                                                                                                                           | [サーバーエラー](#api-error-repeated-529-overloaded-errors)                                              |
| `Request timed out`                                                                                                                                                                                   | [サーバーエラー](#request-timed-out)、またはメッセージがインターネット接続に言及している場合は [ネットワーク](#unable-to-connect-to-api)    |
| `API Error: No response from API`                                                                                                                                                                     | [サーバーエラー](#no-response-from-api)                                                                  |
| `Server error mid-response. The response above may be incomplete.`                                                                                                                                    | [サーバーエラー](#the-response-above-may-be-incomplete)                                                  |
| `Connection lost mid-response` / `Your computer went to sleep mid-response` / `The response stopped arriving`                                                                                         | [サーバーエラー](#the-response-above-may-be-incomplete)                                                  |
| `Connection closed mid-response` / `Response stalled mid-stream`                                                                                                                                      | [サーバーエラー](#the-response-above-may-be-incomplete)                                                  |
| `Connection lost before a response was produced` / `Your computer went to sleep before a response was produced` / `The response stalled before a response was produced`                               | [自動再試行](#automatic-retries)                                                                       |
| `Connection closed while thinking` / `Response stalled while thinking`                                                                                                                                | [自動再試行](#automatic-retries)                                                                       |
| `Connection lost while your computer was asleep`                                                                                                                                                      | [自動再試行](#automatic-retries)                                                                       |
| `<model> is temporarily unavailable, so auto mode cannot determine the safety of...`                                                                                                                  | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
| `Auto mode could not evaluate this action and is blocking it for safety`                                                                                                                              | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
| `Auto mode classifier transcript exceeded context window`                                                                                                                                             | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
| `Agent aborted: auto mode classifier request refused by the safety safeguard`                                                                                                                         | [サーバーエラー](#auto-mode-cannot-determine-the-safety-of-an-action)                                    |
| `Agent terminated early due to an API error`                                                                                                                                                          | [サーバーエラー](#agent-terminated-early-due-to-an-api-error)                                            |
| `You've hit your session limit` / `You've hit your weekly limit` / `You've hit your Opus limit` / `You've hit your Sonnet limit`                                                                      | [使用制限](#youve-hit-your-session-limit)                                                             |
| `Usage credits required for 1M context`                                                                                                                                                               | [使用制限](#usage-credits-required-for-1m-context)                                                    |
| `the prompt to confirm went unanswered — nothing was sent`                                                                                                                                            | [使用制限](#the-prompt-to-confirm-went-unanswered)                                                    |
| `Server is temporarily limiting requests`                                                                                                                                                             | [使用制限](#server-is-temporarily-limiting-requests)                                                  |
| `Request rejected (429)`                                                                                                                                                                              | [使用制限](#request-rejected-429)                                                                     |
| `Credit balance is too low`                                                                                                                                                                           | [使用制限](#credit-balance-is-too-low)                                                                |
| `Could not update your spend limit`                                                                                                                                                                   | [使用制限](#could-not-update-your-spend-limit)                                                        |
| `spend limit reached` / `spend limit unavailable`                                                                                                                                                     | [使用制限](#spend-limit-reached)                                                                      |
| `Not logged in · Please run /login`                                                                                                                                                                   | [認証](#not-logged-in)                                                                              |
| `Could not resolve authentication method`                                                                                                                                                             | [認証](#could-not-resolve-authentication-method)                                                    |
| `Invalid API key`                                                                                                                                                                                     | [認証](#invalid-api-key)                                                                            |
| `Your apiKeyHelper script is failing`                                                                                                                                                                 | [認証](#your-apikeyhelper-script-is-failing)                                                        |
| `Invalid auth token · Fix external auth token`                                                                                                                                                        | [認証](#invalid-request-header-value)                                                               |
| `Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable`                                                                                                                                     | [認証](#invalid-request-header-value)                                                               |
| `Invalid request header from the environment · Fix the environment variable`                                                                                                                          | [認証](#invalid-request-header-value)                                                               |
| `This organization has been disabled`                                                                                                                                                                 | [認証](#this-organization-has-been-disabled)                                                        |
| `Your organization has disabled API key authentication`                                                                                                                                               | [認証](#your-organization-has-disabled-api-key-authentication)                                      |
| `Your organization has disabled Claude subscription access`                                                                                                                                           | [認証](#your-organization-has-disabled-claude-subscription-access)                                  |
| `Routines are disabled by your organization's policy`                                                                                                                                                 | [認証](#routines-are-disabled-by-your-organizations-policy)                                         |
| `Remote Control is only available when using Claude via api.anthropic.com`                                                                                                                            | [認証](#remote-control-requires-the-anthropic-api)                                                  |
| `OAuth token refresh failed — run /login to re-authenticate`                                                                                                                                          | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `JWT refresh failed: no OAuth token — run /login`                                                                                                                                                     | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `Claude.ai login expired`                                                                                                                                                                             | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `Claude.ai login was rejected — run /login, then /remote-control`                                                                                                                                     | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `OAuth token unavailable — run /login to restore Remote Control`                                                                                                                                      | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `Signed out of Claude — run /login, then /remote-control`                                                                                                                                             | [認証](#remote-control-couldnt-refresh-your-login)                                                  |
| `signed-in claude.ai account or organization changed on this machine`                                                                                                                                 | [認証](#remote-control-stopped-because-the-signed-in-account-changed)                               |
| `Remote Control stopped — the app running this session is now signed in to a different Claude account`                                                                                                | [認証](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `Remote Control stopped — the app running this session is signed out of Claude`                                                                                                                       | [認証](#remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts) |
| `OAuth token revoked` / `OAuth token has expired`                                                                                                                                                     | [認証](#oauth-token-revoked-or-expired)                                                             |
| `API Error: 401 Invalid authentication credentials`                                                                                                                                                   | [認証](#api-error-401-invalid-authentication-credentials)                                           |
| `Login expired · Please run /login`                                                                                                                                                                   | [認証](#login-expired)                                                                              |
| `Failed to authenticate: OAuth session expired and could not be refreshed`                                                                                                                            | [認証](#login-expired)                                                                              |
| `Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted`                                                                                             | [認証](#your-account-is-on-hold)                                                                    |
| `Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted`                                                                                      | [認証](#your-account-is-on-hold)                                                                    |
| `Anthropic profile login expired · Re-authenticate your Anthropic profile`                                                                                                                            | [認証](#anthropic-profile-login-expired)                                                            |
| `Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile`                                                                                  | [認証](#anthropic-profile-login-expired)                                                            |
| `does not meet scope requirement user:profile`                                                                                                                                                        | [認証](#oauth-scope-requirement)                                                                    |
| `claude.ai rejected the session token` / `session token rejected`                                                                                                                                     | [認証](#claude-ai-rejected-the-session-token)                                                       |
| `Issuer mismatch in authorization response (RFC 9207)`                                                                                                                                                | [認証](#issuer-mismatch-in-authorization-response)                                                  |
| `Cloud gateway session expired — run /login to reconnect.`                                                                                                                                            | [認証](#cloud-gateway-session-expired)                                                              |
| `Cloud gateway <url> no longer accepts this session`                                                                                                                                                  | [認証](#cloud-gateway-session-expired)                                                              |
| `AWS credentials expired or invalid`                                                                                                                                                                  | [認証](#aws-credentials-expired-or-invalid)                                                         |
| `AWS authentication failed`                                                                                                                                                                           | [認証](#aws-authentication-failed)                                                                  |
| `AWS default-chain credential resolve timed out`                                                                                                                                                      | [認証](#aws-default-chain-credential-resolve-timed-out)                                             |
| `Could not load the default credentials` on Google Cloud's Agent Platform                                                                                                                             | [自動再試行](#automatic-retries)                                                                       |
| `Unable to connect to API`                                                                                                                                                                            | [ネットワーク](#unable-to-connect-to-api)                                                               |
| `Connection refused —` / `Can't reach the API server —` / `No internet route —` / `Couldn't connect through your proxy` / `Connection dropped`、各々括弧内のエラーコードで終わる                                       | [ネットワーク](#unable-to-connect-to-api)                                                               |
| `Unable to connect to Anthropic services` during setup                                                                                                                                                | [ネットワーク](#unable-to-connect-to-anthropic-services)                                                |
| `Socket is closed`                                                                                                                                                                                    | [ネットワーク](#socket-is-closed)                                                                       |
| `Waiting for API response · will retry in`                                                                                                                                                            | [自動再試行](#automatic-retries)、または継続する場合は [ネットワーク](#unable-to-connect-to-api)                        |
| `API returned an empty or malformed response`                                                                                                                                                         | [ネットワーク](#api-returned-an-empty-or-malformed-response)                                            |
| `Streaming response ended before any complete data was received`                                                                                                                                      | [ネットワーク](#streaming-response-ended-before-any-complete-data-was-received)                         |
| `Bedrock streaming response has content-type "..."; expected "application/vnd.amazon.eventstream"`                                                                                                    | [ネットワーク](#bedrock-streaming-response-has-an-unexpected-content-type)                              |
| `SSL certificate verification failed`                                                                                                                                                                 | [ネットワーク](#ssl-certificate-errors)                                                                 |
| `SSL certificate error (...)` during login or startup                                                                                                                                                 | [ネットワーク](#ssl-certificate-errors)                                                                 |
| `403` with `x-deny-reason: host_not_allowed` in a cloud or routine session                                                                                                                            | [ネットワーク](#host-not-allowed-in-a-cloud-session)                                                    |
| `proxy refused the connection`                                                                                                                                                                        | [ネットワーク](#the-proxy-refused-the-connection)                                                       |
| `403` with `This GraphQL query is not enabled for this session` in a cloud session                                                                                                                    | [GitHub proxy](/docs/ja/cloud-environments#github-proxy)                                               |
| `The cloud environments service returned an empty response` / `The cloud environments service returned a response in an unexpected format`                                                            | [ネットワーク](#the-cloud-environments-service-returned-an-empty-or-unexpected-response)                |
| `Couldn't reconnect to your Remote Control session`                                                                                                                                                   | [ネットワーク](#couldnt-reconnect-to-your-remote-control-session)                                       |
| `N sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.`                                                                                | [ネットワーク](#sessions-ended-while-this-machine-was-offline)                                          |
| `Couldn't share the transcript.`                                                                                                                                                                      | [ネットワーク](#couldnt-share-the-transcript)                                                           |
| `Prompt is too long` / `Input is too long for requested model`                                                                                                                                        | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `Prompt is too long · automatic compaction failed:`                                                                                                                                                   | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `Prompt is too long · this conversation is a single exchange` / `A single-exchange conversation cannot be compacted`                                                                                  | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `Context limit reached · /compact or /clear to continue`                                                                                                                                              | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `Context limit reached · /clear to continue`                                                                                                                                                          | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `capability_rejected: prompt_too_long` on a Claude apps gateway session                                                                                                                               | [リクエストエラー](#prompt-is-too-long)                                                                   |
| `upstream rejected the request` / `request too large for this upstream` on a Claude apps gateway session                                                                                              | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages)                 |
| `upstream rate limit exceeded` on a Claude apps gateway session                                                                                                                                       | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages)                 |
| `all upstreams failed (N attempted)` on a Claude apps gateway session                                                                                                                                 | [Upstream error messages](/docs/ja/claude-apps-gateway-config#upstream-error-messages)                 |
| `Context exceeds the ...-token limit by ... tokens` in `/context` output                                                                                                                              | [リクエストエラー](#context-exceeds-the-token-limit)                                                      |
| `Error during compaction: Conversation too long`                                                                                                                                                      | [リクエストエラー](#error-during-compaction-conversation-too-long)                                        |
| `Request too large`                                                                                                                                                                                   | [リクエストエラー](#request-too-large)                                                                    |
| `Request too large for the API's 32MB request limit`                                                                                                                                                  | [リクエストエラー](#request-too-large)                                                                    |
| `Image was too large`                                                                                                                                                                                 | [リクエストエラー](#image-was-too-large)                                                                  |
| `Unable to resize image`                                                                                                                                                                              | [リクエストエラー](#unable-to-resize-image)                                                               |
| `PDF too large` / `PDF is password protected`                                                                                                                                                         | [リクエストエラー](#pdf-errors)                                                                           |
| `Extra inputs are not permitted`                                                                                                                                                                      | [リクエストエラー](#extra-inputs-are-not-permitted)                                                       |
| `API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid` / `Property keys should match pattern`                                                                                       | [リクエストエラー](#tool-input-schema-is-invalid)                                                         |
| `There's an issue with the selected model`                                                                                                                                                            | [リクエストエラー](#theres-an-issue-with-the-selected-model)                                              |
| `Model ... is not a recognized model id`                                                                                                                                                              | [リクエストエラー](#model-is-not-a-recognized-model-id)                                                   |
| `Claude Opus is not available with the Claude Pro plan`                                                                                                                                               | [リクエストエラー](#claude-opus-is-not-available-with-the-claude-pro-plan)                                |
| `Claude Code ... does not support this model; version ... or newer is required`                                                                                                                       | [リクエストエラー](#claude-code-does-not-support-this-model)                                              |
| `Model ... is restricted by your organization's settings`                                                                                                                                             | [リクエストエラー](#model-is-restricted-by-your-organizations-settings)                                   |
| `Model switch ... blocked by a PreModelSwitch hook`                                                                                                                                                   | [リクエストエラー](#model-switch-was-blocked-by-a-premodelswitch-hook)                                    |
| `thinking.type.enabled is not supported for this model`                                                                                                                                               | [リクエストエラー](#thinking-type-enabled-is-not-supported-for-this-model)                                |
| `Effort '<level>' isn't available with thinking turned off on this model`                                                                                                                             | [リクエストエラー](#effort-isnt-available-with-thinking-turned-off)                                       |
| `effort '<level>' is not supported when thinking is disabled`                                                                                                                                         | [リクエストエラー](#effort-isnt-available-with-thinking-turned-off)                                       |
| `max_tokens must be greater than thinking.budget_tokens`                                                                                                                                              | [リクエストエラー](#thinking-budget-exceeds-output-limit)                                                 |
| `API Error: 400 due to tool use concurrency issues`                                                                                                                                                   | [リクエストエラー](#tool-use-or-thinking-block-mismatch)                                                  |
| `[Unsupported tool content removed]`                                                                                                                                                                  | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
| `server_tool_use.name: Input should be` on every turn of a resumed session                                                                                                                            | [リクエストエラー](#unsupported-tool-content-removed)                                                     |
| `<model> can't help with this. Start a new session to continue`                                                                                                                                       | [リクエストエラー](#usage-policy-refusal)                                                                 |
| `Claude Code is unable to respond to this request, which appears to violate our Usage Policy`                                                                                                         | [リクエストエラー](#usage-policy-refusal)                                                                 |
| `<model>'s safeguards flagged this message`                                                                                                                                                           | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic)                                        |
| `<model> has safety measures that flagged this message for a cybersecurity topic`                                                                                                                     | [リクエストエラー](#safety-measures-flagged-a-cybersecurity-topic)                                        |
| `Installation was killed before it could finish (exit code 137)`                                                                                                                                      | [インストールエラー](#installation-was-killed-before-it-could-finish)                                      |
| `The connection dropped while downloading the update`                                                                                                                                                 | [インストールエラー](#the-connection-dropped-while-downloading-the-update)                                 |
| `Download timed out: exceeded the total deadline`                                                                                                                                                     | [インストールエラー](#the-connection-dropped-while-downloading-the-update)                                 |
| `--bg and --print conflict`                                                                                                                                                                           | [コマンドラインエラー](#command-line-errors)                                                                |
| `Cloud sessions cannot be created from a --restricted session`                                                                                                                                        | [コマンドラインエラー](#cloud-sessions-cannot-be-created-from-a-restricted-session)                         |
| `Error: --json-schema is not a valid JSON Schema`                                                                                                                                                     | [コマンドラインエラー](#command-line-errors)                                                                |
| `Error: Invalid --agents configuration:`                                                                                                                                                              | [コマンドラインエラー](#invalid-agents-configuration)                                                       |
| `Error: Settings file exceeds the 2MiB limit`                                                                                                                                                         | [コマンドラインエラー](#settings-file-exceeds-the-2mib-limit)                                               |
| `The current directory no longer exists (it was deleted or moved)` / `Can't read the current directory`                                                                                               | [コマンドラインエラー](#the-current-directory-no-longer-exists)                                             |
| `Error: Workspace not trusted` when starting Remote Control                                                                                                                                           | [コマンドラインエラー](#workspace-not-trusted-when-starting-remote-control)                                 |
| `` `<flag>` before `remote-control` is not carried over to the sessions Remote Control starts ``                                                                                                      | [コマンドラインエラー](#not-carried-over-to-the-sessions-remote-control-starts)                             |
| `` `claude import` is not yet available in this build ``                                                                                                                                              | [コマンドラインエラー](#claude-import-is-not-yet-available-in-this-build)                                   |
| `Could not read Claude Code config`                                                                                                                                                                   | [コマンドラインエラー](#could-not-read-claude-code-config)                                                  |
| `Could not import <server>: <reason>`                                                                                                                                                                 | [コマンドラインエラー](#could-not-import-a-server-from-claude-desktop)                                      |
| `is Anthropic-hosted and doesn't support local OAuth`                                                                                                                                                 | [コマンドラインエラー](#anthropic-hosted-and-doesnt-support-local-oauth)                                    |
| `Server rejected the Authorization header minted by the configured headersHelper`                                                                                                                     | [コマンドラインエラー](#server-rejected-the-authorization-header-minted-by-the-configured-headershelper)    |
| `Error: MCP tool <name> (passed via --permission-prompt-tool) not found`                                                                                                                              | [コマンドラインエラー](#mcp-permission-prompt-tool-not-found)                                               |
| `Shell command failed for pattern "..."`, from `/security-review` or any skill that injects dynamic context                                                                                           | [コマンドラインエラー](#security-review-fails-without-origin-head)                                          |
| `Shell command permission check failed for pattern "..."`, from a skill that injects dynamic context                                                                                                  | [コマンドラインエラー](#security-review-fails-without-origin-head)                                          |
| ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found``                                                                                                              | [コマンドラインエラー](#security-review-fails-without-origin-head)                                          |
| `Input must be provided either through stdin or as a prompt argument when using --print`                                                                                                              | [コマンドラインエラー](#input-must-be-provided-when-using-print)                                            |
| `Error: Input contained only whitespace`                                                                                                                                                              | [コマンドラインエラー](#input-contained-only-whitespace)                                                    |
| `Blank prompt — the message was only whitespace, so nothing was sent to the model.`                                                                                                                   | [コマンドラインエラー](#input-contained-only-whitespace)                                                    |
| `Unknown command: /<name>`, with or without a `Did you mean` suggestion                                                                                                                               | [コマンドラインエラー](#unknown-command)                                                                    |
| `Diff is too large for ultrareview` / `PR #<N> is too large for ultrareview`                                                                                                                          | [コマンドラインエラー](#diff-is-too-large-for-ultrareview)                                                  |
| `Could not find merge-base with <branch>`                                                                                                                                                             | [コマンドラインエラー](#could-not-find-merge-base-with-the-base-branch)                                     |
| `Your checkout has no branches (detached HEAD only)`                                                                                                                                                  | [コマンドラインエラー](#your-checkout-has-no-branches)                                                      |
| `Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected`                                                                      | [コマンドラインエラー](#no-github-account-is-connected-to-your-claude-account)                              |
| `Your connected GitHub account can't see <owner>/<repo>`                                                                                                                                              | [コマンドラインエラー](#your-connected-github-account-cant-see-the-repository)                              |
| `The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead`                                                                            | [コマンドラインエラー](#the-github-app-preflight-failed-transiently)                                        |
| `Failed to resume the conversation`                                                                                                                                                                   | [コマンドラインエラー](#failed-to-resume-the-conversation)                                                  |
| `No conversation found with session ID: <session-id>`                                                                                                                                                 | [コマンドラインエラー](#no-conversation-found-with-the-session-id)                                          |
| `Cannot switch renderers in this session`                                                                                                                                                             | [コマンドラインエラー](#cannot-switch-renderers-in-this-session)                                            |
| `Cannot switch renderers while work is running in the background`                                                                                                                                     | [コマンドラインエラー](#cannot-switch-renderers-in-this-session)                                            |
| `Couldn't read your Zed keymap` / `Couldn't back up your Zed keymap` / `Couldn't update your Zed keymap`                                                                                              | [コマンドラインエラー](#terminal-setup-left-your-zed-keymap-unchanged)                                      |
| `Your Zed keymap isn't a readable list of keybindings`                                                                                                                                                | [コマンドラインエラー](#terminal-setup-left-your-zed-keymap-unchanged)                                      |
| `Skill usage reports are not available on this connection.`                                                                                                                                           | [コマンドラインエラー](#skill-usage-reports-are-not-available-on-this-connection)                           |
| `Marketplace "<name>" is registered from an untrusted source`                                                                                                                                         | [プラグインエラー](#marketplace-is-registered-from-an-untrusted-source)                                   |
| `references ${user_config.*} in a shell-form command`                                                                                                                                                 | [プラグインエラー](#plugin-command-references-user-config)                                                |
| `Monitor "<name>" from plugin <plugin> references ${user_config.*} in its command`                                                                                                                    | [プラグインエラー](#plugin-command-references-user-config)                                                |
| `headersHelper for MCP server '<name>' references ${user_config.*}`                                                                                                                                   | [プラグインエラー](#plugin-command-references-user-config)                                                |
| `Plugin archive integrity check failed`                                                                                                                                                               | [プラグインエラー](#plugin-archive-integrity-check-failed)                                                |
| `path escapes plugin directory`                                                                                                                                                                       | [プラグインエラー](#path-escapes-plugin-directory)                                                        |
| `Failed to load marketplace configuration`                                                                                                                                                            | [プラグインエラー](#failed-to-load-marketplace-configuration)                                             |
| `Marketplace configuration file is corrupted`                                                                                                                                                         | [プラグインエラー](#failed-to-load-marketplace-configuration)                                             |
| `would be spawned with zero tools — refusing`                                                                                                                                                         | [ツールエラー](#agent-would-be-spawned-with-zero-tools)                                                 |
| `File is covered by a Read deny rule in your permission settings`                                                                                                                                     | [ツールエラー](#file-is-covered-by-a-read-deny-rule)                                                    |
| `subagent_type is required: the general-purpose agent is not available in this session`                                                                                                               | [ツールエラー](#subagent-type-is-required)                                                              |
| `Error: this write left the memory index at MEMORY.md at ..., over its ... read limit`                                                                                                                | [ツールエラー](#memory-index-is-over-its-read-limit)                                                    |
| `pkill: refusing to run`                                                                                                                                                                              | [ツールエラー](#pkill-pattern-matches-the-claude-code-process)                                          |
| `Failed to write to <name>'s inbox — nothing was sent`                                                                                                                                                | [ツールエラー](#failed-to-write-to-a-teammate-inbox)                                                    |
| `Failed to write the plan approval request to the lead's inbox — plan not submitted`                                                                                                                  | [ツールエラー](#failed-to-write-to-a-teammate-inbox)                                                    |
| `Message too large for cross-session delivery`                                                                                                                                                        | [ツールエラー](#message-too-large-for-cross-session-delivery)                                           |
| `Too many messages to this session just now`                                                                                                                                                          | [ツールエラー](#too-many-messages-to-this-session-just-now)                                             |
| `Refusing to send: reply target is a symlink` / `Refusing to send: cannot vet reply target`                                                                                                           | [ツールエラー](#refusing-to-send-a-cross-session-message)                                               |
| `Refusing to send: connected endpoint is not the expected process` / `Refusing to send: connected endpoint identity could not be read`                                                                | [ツールエラー](#refusing-to-send-a-cross-session-message)                                               |
| `Refusing to send: connected endpoint is not owned by this user` / `Refusing to send: connected endpoint owner could not be read`                                                                     | [ツールエラー](#refusing-to-send-a-cross-session-message)                                               |
| `Refusing to send: connected endpoint is a different process with the expected pid`                                                                                                                   | [ツールエラー](#refusing-to-send-a-cross-session-message)                                               |
| `Refusing to read <path>: its symlink resolution changed after permission was checked` / `Refusing to search <path>: its symlink resolution changed after permission was checked`                     | [ツールエラー](#refusing-after-a-symlink-changed)                                                       |
| `Refusing to write <path>: its parent-directory symlink resolution changed after permission was checked` / `Refusing to write <path>: it is a symbolic link. Write to the link's target path instead` | [ツールエラー](#refusing-after-a-symlink-changed)                                                       |
| `Refusing to search <path>: a path one of its Read deny rules is written through changed while the search was being prepared` / `Refusing to search <path>: it could not be opened`                   | [ツールエラー](#refusing-after-a-symlink-changed)                                                       |
| `its permission check expired before it ran (too many concurrent file operations)` / `ripgrep was found only by name on PATH`                                                                         | [ツールエラー](#refusing-after-a-symlink-changed)                                                       |
| `task output swap refused (tasks dir moved or linked)`                                                                                                                                                | [ツールエラー](#task-output-swap-refused)                                                               |
| `Can't open MCP settings while no terminal is attached to this background session`                                                                                                                    | [バックグラウンドセッションエラー](#commands-refused-in-a-background-session)                                     |
| `Can't open MCP settings in a background session`                                                                                                                                                     | [バックグラウンドセッションエラー](#commands-refused-in-a-background-session)                                     |
| `blocked because the path is spelled in a form that cannot be safely resolved`                                                                                                                        | [バックグラウンドセッションエラー](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)          |
| `blocked because the path is network-shaped`                                                                                                                                                          | [バックグラウンドセッションエラー](#write-or-command-blocked-because-the-path-names-a-network-location)           |
| `This session has no saved transcript`                                                                                                                                                                | [バックグラウンドセッションエラー](#this-session-has-no-saved-transcript)                                         |
| `Can't open — this session is running in another terminal`                                                                                                                                            | [バックグラウンドセッションエラー](#this-session-is-running-in-another-terminal)                                  |
| `This conversation is already open in another running Claude session`                                                                                                                                 | [バックグラウンドセッションエラー](#this-session-is-running-in-another-terminal)                                  |
| `This session's saved conversation is no longer on disk`                                                                                                                                              | [バックグラウンドセッションエラー](#this-sessions-saved-conversation-is-no-longer-on-disk)                        |
| `kept <id> — worktree has commits that are not pushed anywhere`                                                                                                                                       | [バックグラウンドセッションエラー](#worktree-has-commits-that-are-not-pushed-anywhere)                            |
| `terminal host process died — press Enter to restart` / `This session's terminal host process died`                                                                                                   | [バックグラウンドセッションエラー](#terminal-host-process-died)                                                   |
| `Session isn't responding` / `Press enter again to restart this session — it isn't responding`                                                                                                        | [バックグラウンドセッションエラー](#session-isnt-responding)                                                      |
| `Session <id> was stopped while the respawn was in flight`                                                                                                                                            | [バックグラウンドセッションエラー](#session-was-stopped-while-the-respawn-was-in-flight)                          |
| `This session was running agent '<name>', which is no longer available`                                                                                                                               | [バックグラウンドセッションエラー](#session-agent-no-longer-available)                                            |
| `CLAUDE_CODE_PROCESS_WRAPPER: launcher ...`                                                                                                                                                           | [バックグラウンドセッションエラー](#claude_code_process_wrapper-launcher-errors)                                  |
| `EUNKNOWN: unknown error, uv_spawn`                                                                                                                                                                   | [バックグラウンドセッションエラー](#eunknown-when-starting-a-background-session)                                  |
| `EACCES: permission denied, posix_spawn`                                                                                                                                                              | [バックグラウンドセッションエラー](#eacces-when-starting-a-background-session)                                    |
| `exited before it became reachable`                                                                                                                                                                   | [バックグラウンドセッションエラー](#background-service-exited-before-it-became-reachable)                         |
| `Claude Code is being updated by npm on this machine (still not runnable after 2 min, ...)`                                                                                                           | [バックグラウンドセッションエラー](#eacces-when-starting-a-background-session)                                    |
| `Claude Code process exited with code N`                                                                                                                                                              | [ラッパーと IDE エラー](#claude-code-process-exited-with-code-n)                                          |
| `Could not locate the Claude CLI on PATH`                                                                                                                                                             | [ラッパーと IDE エラー](#could-not-locate-the-claude-cli-on-path)                                         |
| `Restored the code, but skipped N files`                                                                                                                                                              | [Rewind の警告とエラー](#restored-the-code-but-skipped-files)                                            |
| `No files were restored: N files failed (backup missing, or the file could not be updated)`                                                                                                           | [Rewind の警告とエラー](#no-files-were-restored)                                                         |
| `Transcript writes are failing (...)`                                                                                                                                                                 | [セッション保存の警告](#transcript-writes-are-failing)                                                      |
| `Transcript saving is off — CLAUDE_CODE_SKIP_PROMPT_HISTORY is set`                                                                                                                                   | [セッション保存の警告](#transcript-saving-is-off-skip-prompt-history)                                       |
| `Transcript saving is off — inherited CLAUDE_CODE_CHILD_SESSION marker`                                                                                                                               | [セッション保存の警告](#transcript-saving-is-off-child-session-marker)                                      |
| `Claude Code's fullscreen renderer didn't finish starting last time on this machine` / `Claude Code's fullscreen renderer has repeatedly failed to start on this machine`                             | [設定の警告](#fullscreen-failed-start-notice)                                                          |
| `Claude Code exited after an unrecoverable interface error (...)`                                                                                                                                     | [設定の警告](#exited-after-an-unrecoverable-interface-error)                                           |
| `Agent descriptions are over the 15.0k-token limit`                                                                                                                                                   | [設定の警告](#agent-descriptions-are-over-the-15000-token-limit)                                       |
| `Ignoring N permissions.allow entries from ... this workspace has not been trusted`                                                                                                                   | [設定の警告](#workspace-has-not-been-trusted)                                                          |
| `is a network path, which cannot be added as a working directory`                                                                                                                                     | [設定の警告](#working-directory-is-a-network-path)                                                     |
| `Remote managed settings failed to load (<cause>)`                                                                                                                                                    | [設定の警告](#remote-managed-settings-failed-to-load)                                                  |
| `Managed settings were not approved; exiting without applying them.`                                                                                                                                  | [設定の警告](#managed-settings-were-not-approved)                                                      |
| `MCP server <name> is blocked by enterprise managed policy`                                                                                                                                           | [設定の警告](#mcp-server-is-blocked-by-enterprise-managed-policy)                                      |
| `Managed settings document could not be parsed as a JSON object; none of its settings are in effect. Fix or remove it.`                                                                               | [設定の警告](#managed-settings-document-could-not-be-parsed)                                           |
| `Managed settings drop-in directory could not be read`                                                                                                                                                | [設定の警告](#managed-settings-document-could-not-be-parsed)                                           |
| `"crossSessionInbound" must be one of "accept", "hold", "refuse"`                                                                                                                                     | [設定の警告](#crosssessioninbound-must-be-one-of-accept-hold-refuse)                                   |
| `headersHelper not run — this workspace has no persisted trust`                                                                                                                                       | [設定の警告](#headershelper-not-run)                                                                   |
| `Invalid permission rule "..." was skipped: Malformed Tool(content) rule`                                                                                                                             | [設定の警告](#malformed-tool-content-rule)                                                             |
| `... is not matched by file permission checks`                                                                                                                                                        | [設定の警告](#is-not-matched-by-file-permission-checks)                                                |
| `... has a wildcard before the rest of the command`                                                                                                                                                   | [設定の警告](#has-a-wildcard-before-the-rest-of-the-command)                                           |
| `CLAUDE_CODE_DISABLE_1M_CONTEXT is set, but the 200K limit isn't enforced`                                                                                                                            | [設定の警告](#the-200k-limit-isnt-enforced)                                                            |
| `[claude-code:unrecognized_model]`                                                                                                                                                                    | [設定の警告](#unrecognized-model-id-on-a-request)                                                      |
| Responses seem lower quality than usual                                                                                                                                                               | [応答品質](#responses-seem-lower-quality-than-usual)                                                  |

<h2 id="automatic-retries">
  自動リトライ
</h2>

Claude Code は、エラーを表示する前に、指数バックオフを使用して一時的な障害を最大 10 回までリトライします。Claude の応答の途中で到着した障害は、常にリトライされるわけではありません。このページのエラーが表示された場合、Claude Code はその障害に適用されるリトライをすでに実行しています。以下のリストは、どの障害が完全な予算を取得し、どの障害がより小さい予算を取得し、どの障害が予算を取得しないかを示しています。

Claude Code がリトライする障害：

* Claude の応答がストリーミングされる前に到着するサーバーエラー、オーバーロード応答、およびリクエストタイムアウト。
* 接続の切断。Claude が応答の任意の部分（思考を含む）を完了する前にリクエストの途中で接続が切断された場合、Claude Code はバックオフを同じにしてリクエストを再発行し、テキストがすでにストリーミングを開始していても、ターンは続行されます。Claude が思考を完了した後、テキストまたはツール呼び出しを開始する前に接続が切断された場合、Claude Code は代わりにリクエストを最大 2 回迅速に連続して再発行し、接続がその時点で切断され続ける場合は `Connection lost before a response was produced` でターンを終了します。
* Claude Code がリクエストの途中でコンピューターがスリープ状態になったことによって破損したと検出した接続。Claude Code はそれを上記のルールに基づいて切断された接続としてカウントします。リトライラベルが特定の理由を名前付けすると、`Connection lost while your computer was asleep` と読み、Claude が思考を完了した後、テキストまたはツール呼び出しの前にターンが終了する場合、メッセージは `Your computer went to sleep before a response was produced` と読みます。
* 応答ヘッダーが到着したが Claude の応答が何も到着していない場合、または Claude が思考を完了したがテキストまたはツール呼び出しを開始していない場合の、停滞した応答ストリーム。Claude Code は停滞した接続を中止し、上記の 10 回の試行予算の外で最大 1 回リクエストを再発行します。Claude が思考を完了した後、テキストまたはツール呼び出しの前に応答が 2 回目に停滞した場合、Claude Code は `The response stalled before a response was produced` でターンを終了します。
* API が応答ヘッダーで応答しないストリーミングリクエスト。[最初のバイトのデッドラインが実行される](/docs/ja/network-config#streaming-idle-watchdogs)接続上：Claude Code はデッドラインで中止し、リトライ予算内でモデルリクエストごとに最大 1 回再送信し、その試行も応答がない場合は [No response from API](#no-response-from-api) でターンを終了します。他の接続では、リクエストは `API_TIMEOUT_MS` を待ちます。`CLAUDE_CODE_RETRY_WATCHDOG` を設定すると、1 回のリトライ上限は適用されません。
* 一時的な 429 スロットル。ただし、ゲートウェイの支出制限 `429` は除きます。これはスロットルではありません。[Spend limit reached](#spend-limit-reached) を参照してください。
  * claude.ai サブスクリプションでサインインしている場合、これには計画の割り当てヘッダーを含まない 429 スロットルが含まれます。v2.1.199 より前は、Claude Code は API キーおよび Enterprise サインインに対してのみそれらのスロットルをリトライしました。
* 入力と `max_tokens` がコンテキスト制限を超えるため拒否されたリクエスト。変更されていない状態で再送信すると同じ方法で失敗するため、Claude Code は削減された `max_tokens` でリトライし、2 つのケースでリトライを停止してコンパクト化します：
  * 削減が適合できない場合。たとえば、会話自体がコンテキストウィンドウをほぼ満たしている場合。
  * リトライが `max_tokens` をこれ以上縮小できない場合。v2.1.218 より前は、Claude Code は拡張思考予算が残りのコンテキストを超えた場合など、削減されたリクエストを再送信できましたが、それでも適合しませんでした。リトライ予算が尽きるまで。
* [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) 上の期限切れまたは欠落している Google Cloud 認証情報。`Could not load the default credentials` などのエラーとして表示されます。Claude Code はキャッシュされた認証情報を破棄し、最大 2 回リトライし、設定した場合は [`gcpAuthRefresh`](/docs/ja/google-vertex-ai#advanced-credential-configuration) コマンドを実行し、エラーを報告して、すぐに再認証できるようにします。[Google Cloud の Agent Platform トラブルシューティング](/docs/ja/google-vertex-ai#troubleshooting)は再認証をカバーしています。v2.1.228 より前は、Claude Code はエラーを表示する前に、失敗した認証情報を完全なリトライ予算を通じてリトライしました。
* Anthropic API から直接、または [LLM ゲートウェイ](/docs/ja/llm-gateway) を通じて、[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトが認証情報を提供している間の `401` または `403`。Claude Code はスクリプトを再実行し、完全なリトライ予算内でその新しい出力でリトライします。スクリプト自体が再実行時に失敗した場合、Claude Code は [Your apiKeyHelper script is failing](#your-apikeyhelper-script-is-failing) を代わりに表示します。

v2.1.227 より前は、`Connection lost before a response was produced` は `Connection closed while thinking, before producing a response` と読み、`The response stalled before a response was produced` は `Response stalled while thinking, before producing a response` と読みました。

Claude Code がリトライしない障害：

* TLS 証明書検証エラー。TLS 検査プロキシ、欠落している `NODE_EXTRA_CA_CERTS` バンドル、または期限切れの証明書など。Claude Code は最初の試行でエラーを報告するため、証明書セットアップをすぐに修正できます。[SSL certificate errors](#ssl-certificate-errors) を参照してください。Claude Code は、ハンドシェイクタイムアウトなどの一時的な TLS 条件をリトライします。v2.1.199 より前は、Claude Code は証明書エラーを完全なリトライ予算を通じてリトライしてからエラーを表示しました。
* Claude がテキストまたはツール呼び出しのブロックを完了した後、または思考を完了した後に 1 つを開始した後、応答を完了する前に到着するサーバーエラー、切断された接続、または停滞したストリーム。Claude Code はリクエストを再実行しません。同じツール呼び出しを 2 回実行する可能性があるためです。Claude が完了したものを保持し、Claude が完了したツール呼び出しを実行し、その結果からターンを続行します。対話型セッションと非対話型セッションで表示される内容については、[The response above may be incomplete](#the-response-above-may-be-incomplete) を参照してください。v2.1.199 より前は、サーバーエラーがストリーム中に到着したときに Claude Code は部分的な出力を破棄し、ターン全体をエラーとして報告しました。
* Claude が応答を完了した後に到着する障害：リトライする必要がないため、Claude Code は完全な応答を保持し、ターンを正常に終了します。
* [Amazon Bedrock ストリーミング応答に予期しないコンテンツタイプがある](#bedrock-streaming-response-has-an-unexpected-content-type)。ゲートウェイまたはプロキシが応答を書き直すため、リトライも同じ方法で書き直されます。Claude Code v2.1.208 以降が必要です。
* 失敗したストリーミングリクエストの非ストリーミングリトライが成功ステータスを取得しますが、[本文に Claude API メッセージがない](#api-returned-an-empty-or-malformed-response)。Claude Code はそのエラーでターンを終了します。
* 組織のポリシーチェックが拒否したリクエスト。`API Error:` 行として表示され、拒否メッセージが含まれます。組織の管理者は [Inference hooks](https://platform.claude.com/docs/en/manage-claude/inference-hooks)（Claude Enterprise 機能）でチェックを設定し、メッセージは設定した指示で終わるか、デフォルトではお問い合わせするよう指示します。Claude Code は、拒否がモデルではなくリクエストのコンテンツに関するものであるため、拒否されたリクエストを同じモデルまたは [fallback model](/docs/ja/model-config#fallback-model-chains) に再送信しません。v2.1.239 より前は、Claude Code は拒否されたリクエストを再送信でき、ストリーミングなしで、または設定されたフォールバックモデルで、拒否を表示する前に。

<h3 id="what-you-see-while-claude-code-retries-or-waits">
  Claude Code がリトライまたは待機している間に表示される内容
</h3>

リトライ中、スピナーはエラーラベルの後に `Retrying in Ns · attempt x/y` カウントダウンを表示します。ラベルは、すぐに対応できる障害の最初の試行からの特定の理由を名前付けします。ネットワークがダウンしている、TLS ハンドシェイクが失敗した、またはレート制限に達した場合。他のエラーの場合は、最初は `API error` と読みます。v2.1.198 以降、3 回目の試行からの特定の理由に切り替わるか、`CLAUDE_CODE_MAX_RETRIES` が 3 未満の試行を許可する場合は最終試行時に切り替わります。以前のバージョンは最終試行時にのみ切り替わります。

v2.1.198 以降、通常のスピナーのヒントはリトライ中に抑制されます。エラーの理由が明らかになると、障害が 529 オーバーロードの場合、カウントダウンの下の行はサービスステータスを確認する場所も名前付けします。Anthropic API の `status.claude.com`、または他の設定のメッセージで名前付けされたプロバイダーまたはゲートウェイホスト。

リクエストがまだ保留中の間、応答ストリームで 20 秒間データが到着しない場合、スピナーはリトライが開始される前に `Waiting for API response · will retry in … · check your network` を表示します。リクエストはまだ失敗していません。カウントダウンは Claude Code が停滞した接続を中止する時点まで実行されます。中止後、表示される内容は応答がどこまで進んだかによって異なります：

* Claude がテキストまたはツール呼び出しのブロックを完了する前、または思考を完了した後に 1 つを開始する前に、Claude Code はリクエストをリトライするか、エラーでターンを終了します。[Automatic retries](#automatic-retries) は、どの停滞をリトライし、何回リトライするかを示しています。
* Claude がテキストまたはツール呼び出しのブロックを完了した後、または思考を完了した後に 1 つを開始した後、応答を完了する前に、Claude Code は Claude が完了したものを保持し、Claude が完了したツール呼び出しからターンを続行し、[The response above may be incomplete](#the-response-above-may-be-incomplete) を表示します。非対話型セッション、およびセッション内のサブエージェントの応答では、Claude Code は最初に Claude に応答を続行するよう促す場合があります。そのエントリは、いつそれを行うか、いつそこでも通知が表示されるかを示しています。
* Claude が応答を完了した後、Claude Code はターンを正常に終了します。

バナーは、データが再開されるか、リトライが成功すると自動的にクリアされます。すべての試行で再表示される場合は、[network issue](#unable-to-connect-to-api) として扱ってください。v2.1.185 より前は、バナーは 10 秒後に異なる文言で表示されました。

Claude が [advisor](/docs/ja/advisor) を参照している間、バナーは 20 秒ではなく 90 秒後にデータなしで表示されます。長いアドバイザーレビューは 20 秒以上何も送信しないことがあるためです。v2.1.214 より前は、20 秒のしきい値がアドバイザー呼び出し中にも適用されたため、バナーは何も問題がなくてもアドバイザーレビュー中に表示されました。

<h3 id="tune-retry-behavior">
  リトライ動作を調整する
</h3>

これらの環境変数を使用してリトライ動作を調整できます：

| 変数                                                    | デフォルト  | 効果                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :---------------------------------------------------- | :----- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`CLAUDE_CODE_MAX_RETRIES`](/docs/ja/env-vars)             | 10     | リトライ試行の回数。v2.1.186 以降は 15 でキャップされます。v2.1.199 以降、`CLAUDE_CODE_RETRY_WATCHDOG` はデフォルトを上げ、キャップを削除します。スクリプトで障害をより速く表示するには、これを低くします。                                                                                                                                                                                                                                                                                         |
| [`CLAUDE_CODE_RETRY_WATCHDOG`](/docs/ja/env-vars)          | 未設定    | CI ジョブなどの無人セッションで `1` に設定して、`CLAUDE_CODE_MAX_RETRIES` 試行後に失敗する代わりに、`429` および `529` 容量エラーを無期限にリトライします。Claude Code は、支出制限またはスケジュールでリセットされる [gateway spend cap](#spend-limit-reached) からのものであっても、使用クレジットが枯渇した `429` で一度に失敗します。v2.1.239 より前は、ウォッチドッグはこれらを無期限にリトライしました。v2.1.199 以降では、サーバーエラー、タイムアウト、切断された接続などの他の一時的なエラーのデフォルトリトライ数も 300 に上げます。これは約 3 時間のバックオフであり、`CLAUDE_CODE_MAX_RETRIES` の 15 のキャップを削除します。その変数を明示的に設定した場合。 |
| [`API_TIMEOUT_MS`](/docs/ja/env-vars)                      | 600000 | リクエストごとのタイムアウト（ミリ秒）。遅いネットワークまたはプロキシの場合は上げます。また、Claude Code が応答ヘッダーを待つ時間の上限も設定します。[No response from API](#no-response-from-api) で説明されています。                                                                                                                                                                                                                                                                               |
| [`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS`](/docs/ja/env-vars) | 未設定    | ストリーミングリクエストの最初の応答バイトのデッドライン（ミリ秒）。Claude Code v2.1.242 以降が必要です。これが未設定の場合に Claude Code がデッドラインを選択する方法については、[No response from API](#no-response-from-api) を参照してください。                                                                                                                                                                                                                                                      |

<h2 id="server-errors">
  サーバーエラー
</h2>

これらのエラーのほとんどは推論プロバイダーから発生します。Anthropic API 上の Anthropic のサービス、および Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、またはカスタムゲートウェイの背後にあるプロバイダーのエンドポイントのサービスです。[Auto mode cannot determine the safety of an action](#auto-mode-cannot-determine-the-safety-of-an-action) と [Agent terminated early due to an API error](#agent-terminated-early-due-to-an-api-error) は、Amazon Bedrock アカウントがクラシファイアーモデルを呼び出せない、またはサブエージェントが使用制限に達したなど、お客様側の原因もカバーしています。

<h3 id="api-error-500-internal-server-error">
  API Error: 500 Internal server error
</h3>

Claude Code は、5xx レスポンスに対して、ステータスコードと API のエラーメッセージを表示します。以下の例は、Anthropic API での 500 レスポンスを示しています。

```text theme={null}
API Error: 500 Internal server error. This is a server-side issue, usually temporary — try again in a moment. If it persists, check https://status.claude.com.
```

末尾の文は、サービスの健全性を確認する場所を示し、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry の設定は、そのプロバイダーのサービスステータスを示します。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストを示します。

これは API 内の予期しない障害を示しています。これはお客様のプロンプト、設定、またはアカウントが原因ではありません。

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

末尾の文は、500 エラーと同じ方法でプロバイダーによって異なります。

529 はお客様の使用制限ではなく、クォータに対してカウントされません。

**対応方法：**

* [status.claude.com](https://status.claude.com) またはメッセージに示されているプロバイダーのステータスページで、容量に関する通知を確認してください
* 数分後に再度試してください
* `/model` を実行して別のモデルに切り替えて、作業を続けてください。容量はモデルごとに追跡されるためです。Claude Code は、1 つのモデルが特に高い負荷を受けている場合、これを行うようにお客様に促します。例えば `Opus is experiencing high load, please use /model to switch to Sonnet` のようなメッセージが表示されます。

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
* 長時間実行されるタスクの場合は、作業をより小さなプロンプトに分割してください
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

どちらの待機も、正の `API_TIMEOUT_MS` より 1 秒少ないを超えず、11 秒未満の正の `API_TIMEOUT_MS` は期限をオフにします。バイトレベルのウォッチドッグは応答ヘッダーが到着した後にのみ開始されるため、その後バイト送信を停止するレスポンスは、この期限ではなく [stalled-stream rules](#automatic-retries) に従います。

**対応方法：**

* メッセージを再度送信してください。元のメッセージはまだ会話に残っているため、長いプロンプトの場合は、全体を貼り付ける代わりに `try again` と入力できます。
* 繰り返される場合は、[network or proxy problem](#unable-to-connect-to-api) として扱ってください。接続を受け入れてリクエストを転送しないプロキシは、すべての試行でこのエラーを生成します。
* ネットワーク上のプロキシまたはゲートウェイが応答を生成完了まで保持する場合は、`API_TIMEOUT_MS` を上げて再試行がより長く待機するようにしてください。Amazon Bedrock では、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` も上げてください。
* 最初の試行がタイムアウトし続け、再試行が成功する場合は、`CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS` を上げて最初の試行も十分に長く待機するようにしてください。

v2.1.242 より前では、Claude Code は応答のない ストリーミングリクエストが失敗する前に、完全な `API_TIMEOUT_MS` リクエストタイムアウト（デフォルトは 10 分）を待機していました。v2.1.261 より前では、再試行は最初の試行と同じ期限を待機し、メッセージは期間を示していませんでした。

<h3 id="the-response-above-may-be-incomplete">
  The response above may be incomplete
</h3>

ストリーミングリクエストがレスポンスの進行中に失敗しました。Claude がテキストのブロックまたはツール呼び出しを完了した後、または思考を終了した後に 1 つを開始した後です。リクエストを再送信すると、同じツール呼び出しが 2 回実行される可能性があるため、Claude Code は Claude が完了した出力を保持し、ターンを破棄する代わりにこの通知を追加します。表示されるバリアントは原因を示します。

```text theme={null}
API Error: Server error mid-response. The response above may be incomplete.
API Error: Connection lost mid-response. The response above may be incomplete.
API Error: Your computer went to sleep mid-response. The response above may be incomplete.
API Error: The response stopped arriving. The response above may be incomplete.
```

* `Server error mid-response`: ストリーム中のオーバーロードまたは 5xx サーバーエラー。このバリアントには Claude Code v2.1.199 以降が必要です。それ以前は、その場合は部分的な出力を破棄し、ターン全体をエラーとして報告していました。
* `Connection lost mid-response`: 接続が切断されました。
* `Your computer went to sleep mid-response`: Claude Code は、レスポンスがストリーミング中にコンピューターがスリープ状態になったことを検出しました。コンピューターが起動すると、Claude Code は接続を破損として扱い、読み取りを停止します。
* `The response stopped arriving`: 接続は開いたままでしたが、データの配信を停止したため、ストリーミングアイドルウォッチドッグがそれを中止しました。v2.1.222 より前では、Claude Code は [gateway](/docs/ja/gateways) 接続で `ANTHROPIC_BASE_URL` または `ANTHROPIC_AWS_BASE_URL` を通じて到達したこのエラーを報告することもできました。サーバーのキープアライブピングがまだ到着している間、解析された応答イベントのみをカウントしたため、アップグレードするとこれらのルートでの偽のタイムアウトが停止します。`ANTHROPIC_BEDROCK_BASE_URL` などのプロバイダーベース URL を通じて到達するゲートウェイは、バイトウォッチドッグでラップされていません。[Streaming idle watchdogs](/docs/ja/network-config#streaming-idle-watchdogs) を参照してください。

v2.1.227 より前では、`Connection lost mid-response` は `Connection closed mid-response` と読まれ、`The response stopped arriving` は `Response stalled mid-stream` と読まれていました。

4 つのケースでは、Claude Code はこの通知をすぐに表示せずに障害を処理します。

* レスポンスの前半で、Claude Code は障害を再試行するか、別のエラーでターンを終了します。[Automatic retries](#automatic-retries) を参照してください。
* これらの障害の 1 つが Claude がレスポンスを完了した後に到着した場合、Claude Code は完全なレスポンスを保持し、この通知なしでターンを正常に終了します。v2.1.222 より前では、Claude Code はレスポンスが完了した後に接続が切断またはスタールした場合、この通知を表示し、レスポンスが完全であったにもかかわらずターンをエラーとして報告していました。
* [non-interactive session](/docs/ja/headless)（`-p` 実行、[Agent SDK](/docs/ja/agent-sdk/overview) 実行、または [cloud session](/docs/ja/claude-code-on-the-web) など）では、カットオフレスポンスがメイン会話にあり、テキストを含むがツール呼び出しを含まない場合、`continue` を自分で送信する必要はありません。Claude Code は部分的な出力を保持し、Claude に停止した場所から続行するよう促します。最大 3 回連続で。この通知は、Claude Code がこれらの継続を使い果たした後にのみ、そのようなレスポンスに対して表示されます。v2.1.246 より前では、Claude Code は最初のカットオフでこの通知を使用してターンを終了していました。
* [subagent](/docs/ja/sub-agents#api-errors-in-subagents)（セッションがインタラクティブかどうかに関わらず）：カットオフレスポンスがテキストを含むがツール呼び出しを含まない場合、Claude Code はサブエージェントに続行するよう促します。通知は、これらの継続が使い果たされた後にのみ、サブエージェントの最後のメッセージになります。v2.1.257 より前では、サブエージェントは最初のカットオフでこの通知を表示していました。

**対応方法：**

* インタラクティブセッションでは、画面に残っているレスポンスを読んでください。Claude Code はエラーの前に Claude が完了したすべてのブロックを保持しますが、ターンが終了するときに中断された最終ブロックを破棄するため、最終文またはツール呼び出しが欠落している可能性があります。`continue` で返信して、Claude が最後に完了したブロックから再開するようにしてください。
* [non-interactive mode](/docs/ja/headless)（`-p`）：
  * デフォルトのテキスト出力では、Claude Code は、ターンの前半から保持している最後に完了したテキストのブロックを出力し、その後このメッセージを出力します。何も保持していない場合、Claude Code はこのメッセージのみを出力します。例えば、Claude Code がターン中に会話をコンパクト化し、そのテキストをクリアしたためです。v2.1.219 より前では、Claude Code は `-p` テキスト出力でこのメッセージのみを出力し、既に生成されたレスポンスを削除していました。
  * `--output-format json` または `stream-json` では、Claude Code はこのメッセージを `result` フィールドで報告します。
  * 接続が安定したら、ターンを続行するために、セッションを再開し、[Continue conversations](/docs/ja/headless#continue-conversations) で説明されているように `continue` を送信してください。

<h3 id="auto-mode-cannot-determine-the-safety-of-an-action">
  Auto mode cannot determine the safety of an action
</h3>

[auto mode](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) がアクションを分類するために使用するモデルが決定を生成できなかったため、auto mode はアクションを自動的に承認しませんでした。表示されるメッセージは、クラシファイアーが失敗した方法によって異なります。

作業ディレクトリ内の読み取り、検索、編集はクラシファイアーをスキップするため、これらすべてのケースで動作し続けます。

クラシファイアーモデルが利用できない場合：

```text theme={null}
<model> is temporarily unavailable, so auto mode cannot determine the safety of <tool> right now. Wait a moment and then try this action again.
```

Claude Code が障害カテゴリを判定できる場合、`temporarily unavailable` の後の括弧内にカテゴリを示します。例えば `<model> is temporarily unavailable (rate-limited), so auto mode cannot determine the safety of <tool> right now`。カテゴリは `(rate-limited)`、`(overloaded)`、`(server error)`、`(timed out)`、`(connection failed)` です。レート制限、オーバーロード、サーバーエラーは一時的で、再試行が機能します。`(timed out)` または `(connection failed)` が繰り返される場合は、接続を確認してください。[Unable to connect to API](#unable-to-connect-to-api) を参照してください。v2.1.229 より前では、メッセージはカテゴリを示さず、`Wait briefly and then try this action again` と読まれていました。

カテゴリが適合しない場合、メッセージは括弧内にカテゴリなしで表示されます。複数の障害がその形式を生成します。[Amazon Bedrock](/docs/ja/amazon-bedrock)（[Mantle endpoint](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) を含む）では、AWS アカウントがメッセージに示されているモデルを呼び出せない場合にも表示され、その障害はアカウントにモデルへのアクセスが付与されるまで、すべての再試行で繰り返されます。

**対応方法：**

* 数秒後に再試行してください。Claude は同じメッセージを見て、通常は自動的に再試行します。一時的な障害は [auto mode eligibility](/docs/ja/permission-modes#eliminate-prompts-with-auto-mode) とは無関係です。設定を変更する必要はありません
* 再試行が失敗し続ける場合は、読み取り専用タスクを続行し、後でブロックされたアクションに戻ってください
* Amazon Bedrock では、メッセージがすべての再試行で返される場合は、アカウントがそれが示すモデルを呼び出せることを確認してください。標準の Amazon Bedrock モデルの場合、[IAM policy](/docs/ja/amazon-bedrock#iam-configuration) がそれを呼び出すことを許可していることを確認してください。Mantle モデル ID の場合は、[AWS アカウントチームに連絡してください](/docs/ja/amazon-bedrock#mantle-endpoint-errors)

OAuth トークンの有効期限が切れたか、別のセッションによってローテーションされたためにクラシファイアーリクエストが失敗した場合、Claude Code はトークンをリフレッシュし、リクエストを 1 回再試行するため、ルーチンのトークン有効期限はこのメッセージとして表示されません。v2.1.216 より前では、有効期限が切れたまたはローテーションされたトークンはすべてのクラシファイアーリクエストに失敗し、トークンがリフレッシュされるまで auto mode はこのメッセージで確認されたすべてのアクションを拒否していました。

クラシファイアーが解析不可能なレスポンスを返した場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — run with --debug for details
```

**対応方法：**

* アクションを再試行してください。これは通常、次の試行で成功します
* `claude --debug` を実行し、アクションを繰り返して、デバッグログで基になるクラシファイアーレスポンスを確認してください

別の API セーフティチェックが、以前の会話コンテンツのためにクラシファイアーリクエストをブロックした場合：

```text theme={null}
Auto mode could not evaluate this action and is blocking it for safety — a safety check separate from auto mode blocked this request because of earlier conversation content — it isn't about the action itself — run with --debug for details
```

Claude Code はアクションを拒否しますが、Claude にこれはアクションが安全でないという判断ではなく、再試行するのではなく他のタスクを続行するよう伝えます。これらの拒否は [auto mode's pause thresholds](/docs/ja/permission-modes#when-auto-mode-falls-back) に対してカウントされません。[non-interactive](/docs/ja/headless) `-p` 実行では、Claude Code は実行を停止しません。Claude が受け取るものは、アクションをリクエストした場所によって異なります。

* [background subagent](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) への `-p` 実行（`--input-format stream-json` なし）では、Claude Code は `Agent aborted: auto mode classifier request refused by the safety safeguard in headless mode` を含むエラー結果を返します
* インタラクティブセッションと `-p` 実行のメイン会話を含む、その他すべての場所では、Claude Code はその拒否を Claude に返します

v2.1.225 より前では、Claude Code はこれらの拒否を一時停止しきい値に対してカウントし、本物のクラシファイアーブロックと同じ拒否メッセージを返していました。

**対応方法：**

* これはお客様のアクションに関する決定ではありません。会話に既にあるコンテンツが、auto mode がクラシファイアーに会話を送信したときに API のセーフティフィルターをトリガーしました
* 再試行は役に立ちません。同じ会話コンテンツがフィルターを再度トリガーします
* インタラクティブセッションでは、別の [permission mode](/docs/ja/permission-modes) に切り替えて、プロンプトが表示されたときにアクションを承認できるようにしてください
* トリガーするコンテンツなしで新しい会話を開始してください

会話がクラシファイアーのコンテキストウィンドウより大きくなった場合：

```text theme={null}
Auto mode classifier transcript exceeded context window — falling back to manual approval (try /compact to reduce conversation size)
```

アクションに何が起こるかは、Claude がそれをリクエストした場所によって異なります。

* インタラクティブセッションでは、auto mode はそのアクションに対して通常の権限プロンプトにフォールバックするため、手動で承認または拒否できます
* [background subagent](/docs/ja/sub-agents#run-subagents-in-foreground-or-background) への [non-interactive](/docs/ja/headless) `-p` 実行（`--input-format stream-json` なし）では、Claude Code は `Agent aborted: auto mode classifier transcript exceeded context window in headless mode` を含むエラー結果を返し、実行は続行されます
* [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) なしの `-p` 実行の他の場所では、フォールバックするプロンプトがないため、アクションは実行されず、実行は続行されます

**対応方法：**

* インタラクティブセッションでは、表示されるプロンプトでアクションを承認または拒否してください
* インタラクティブセッションでは、`/compact` を実行して会話サイズを削減し、後続のアクションがクラシファイアーウィンドウ内に収まるようにしてください

<h3 id="agent-terminated-early-due-to-an-api-error">
  Agent terminated early due to an API error
</h3>

[subagent](/docs/ja/sub-agents) の API リクエストが終了的に失敗しました。例えば、使用制限に達したか、サーバーエラーの再試行が終了したため、サブエージェントはタスクを完了する前に停止しました。このメッセージには Claude Code v2.1.199 以降が必要です。それ以前は、API エラーテキストはサブエージェントの結果であるかのように Claude に返されていました。

```text theme={null}
Agent terminated early due to an API error: <error detail>
```

**対応方法：**

* コロンの後のエラー詳細をこのページの独自のセクション（[Usage limits](#usage-limits) または [Server errors](#server-errors) など）と照合し、そのセクションの手順に従ってください
* 基になるエラーがクリアされたら、Claude にタスクを再試行するか、[resume the subagent](/docs/ja/sub-agents#resume-subagents) するよう依頼してください

レート制限、オーバーロード、またはサーバーエラーがテキスト出力を既に生成したフォアグラウンドサブエージェントを中断する場合、Claude はその部分的な出力を不完全としてマークされた状態で受け取り、このエラーは受け取りません。唯一の出力がツール呼び出しであるサブエージェントもこのエラーを取得します。v2.1.199 では、その形状は代わりに空の部分的な結果を返していました。[API errors in subagents](/docs/ja/sub-agents#api-errors-in-subagents) を参照してください。

<h2 id="usage-limits">
  使用制限
</h2>

このセクションのほとんどのエラーは、アカウントまたはプランに関連付けられたクォータに達したことを意味します。3 つのエラーは異なる動作をします。[`Server is temporarily limiting requests`](#server-is-temporarily-limiting-requests) はプランクォータとは無関係なサーバー側のスロットル、[`Usage credits required for 1M context`](#usage-credits-required-for-1m-context) は使い果たされたクォータではなく権利確認、[`The prompt to confirm went unanswered`](#the-prompt-to-confirm-went-unanswered) は使用クレジット同意プロンプトが未回答で閉じられたことを意味し、クォータに達したかどうかは関係ありません。

<h3 id="youve-hit-your-session-limit">
  You've hit your session limit
</h3>

サブスクリプションプランには、ローリング使用許容量が含まれています。それが尽きると、次のいずれかのメッセージが表示されます。

```text theme={null}
You've hit your session limit · resets 3:45pm
You've hit your weekly limit · resets Mon 12:00am
You've hit your Opus limit · resets 3:45pm
You've hit your Sonnet limit · resets 3:45pm
```

Claude Code はメッセージに表示されたリセット時刻まで、それ以上のリクエストをブロックします。セッション制限と週間制限はすべてのモデル間で共有されるため、モデルを切り替えてもアクセスは復元されません。Opus 制限と Sonnet 制限はそれぞれそのモデルファミリーへのリクエストにのみ適用されるため、`/model` で別のファミリーのモデルに切り替えると、作業を続行できます。

claude.ai サブスクリプションでサインインしたインタラクティブセッションでは、Claude Code はオープンセッションで待機し、リセット直後に中断されたタスクを続行することもできます。待機中、セッションの下部の行は `Usage limit reached · continuing automatically at 3:45pm · esc to cancel` と表示されます。空のプロンプトで `Esc` を押して待機をキャンセルできます。[Wait for a usage limit to reset](/docs/ja/interactive-mode#wait-for-a-usage-limit-to-reset) を参照して、表示内容、待機の開始またはキャンセル方法、自動続行をオフにする方法を確認してください。v2.1.234 より前では、Claude Code はこの待機機能を提供していませんでした。

使用量はセッション許容量と週間許容量に同時にカウントされます。大規模なワークフロー展開など、単一の大量アクティビティのバーストは、セッションウィンドウがリセットされる前に週間許容量を使い果たす可能性があります。

**対応方法：**

* エラーに表示されたリセット時刻まで待機します
* [Desktop app](/docs/ja/desktop) の Code タブでは、セッション制限カードに **Auto-continue when limits reset** チェックボックスが表示されます。週間制限カードには表示されません。チェックされている場合、Desktop app はリセット後に中断されたターンを再試行し、カード上に再試行時刻を表示します。Desktop チェックボックスと CLI の `/config` の **Continue automatically at usage limit** 設定は別個なので、それぞれ個別にオフにしてください。
* Opus または Sonnet 制限の場合は、`/model` を実行してそのファミリー外のモデルに切り替え、作業を続行します。各モデルは独自のプロンプトキャッシュを持つため、次のリクエストは会話全体を再度読み込み、キャッシュヒットはありません。[Switching models](/docs/ja/prompt-caching#switching-models) を参照してください
* `/usage` を実行してプラン制限とリセット時刻を確認します
* `/usage-credits` を実行して Pro と Max で追加使用量を購入するか、Team と Enterprise で管理者にリクエストします。[usage credits for paid plans](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) を参照して、この請求方法を確認してください。
* より高い基本制限のためにプランをアップグレードするには、[claude.com/pricing](https://claude.com/pricing) を参照してください

制限に達する前に残りの許容量を監視するには、`rate_limits` フィールドを [custom status line](/docs/ja/statusline#rate-limit-usage) に追加するか、Desktop app でモデルピッカーの横の [usage ring](/docs/ja/desktop#check-usage) をクリックします。

<h3 id="usage-credits-required-for-1m-context">
  Usage credits required for 1M context
</h3>

選択されたモデルは 1M トークン拡張コンテキストウィンドウを使用し、プランはそれを使用クレジットを通じてのみ含みます。

```text theme={null}
API Error: Usage credits required for 1M context · run /usage-credits to turn them on, or /model to switch to standard context
```

これはクォータ枯渇ではなく、権利確認です。セッション許容量と週間許容量に容量が残っている場合でも発火します。[Extended context](/docs/ja/model-config#extended-context) を参照して、どのプランが 1M コンテキストを直接含み、どのプランが使用クレジットを必要とするかを確認してください。Claude Code は `/model` でモデルを選択するときにこのチェックを実行し、Anthropic API への直接接続でのみ実行されます。`ANTHROPIC_BASE_URL` を [LLM gateway](/docs/ja/llm-gateway) に指定する場合、`/model` は `[1m]` 選択を許可し、ゲートウェイがリクエストが成功するかどうかを決定します。

このエラーがコンテキストが 200K トークンを超えて成長したため会話の途中に表示される場合、Claude Code は自動的に会話を標準コンテキスト制限以下に圧縮し、その後セッションをその制限に保つため、アクションは不要です。v2.1.172 より前のバージョンでは、エラーは `/compact` を含むすべての後続リクエストで繰り返されました。それらのバージョンで復旧するには `/clear` を実行してください。以下の手順は、明示的に `[1m]` モデルを選択した場合に適用されます。

**対応方法：**

* `/model` を実行し、`[1m]` サフィックスなしのバリアントを選択して、標準コンテキストウィンドウにフォールバックします
* メッセージが `/usage-credits` を指定する場合、それを実行して Pro と Max で 1M バリアントのメータリング課金をオンにするか、Team と Enterprise で管理者に使用クレジットをリクエストします
* `/model` の後もエラーが続く場合、1M モデル ID が他の場所に設定されている可能性があります。[Setting your model](/docs/ja/model-config#setting-your-model) を参照して、優先順位順に確認する設定場所を確認してください。
* モデルピッカーから 1M バリアントを完全に削除するには、[`CLAUDE_CODE_DISABLE_1M_CONTEXT=1`](/docs/ja/env-vars) を設定します

<h3 id="the-prompt-to-confirm-went-unanswered">
  The prompt to confirm went unanswered
</h3>

アカウントが [Fable usage-credits consent](/docs/ja/model-config#fable-and-usage-credits) を必要とする場合、Claude Code は Fable リクエストが使用クレジットを請求する前に確認するよう求めます。ターミナルがない可能性があるセッションでその同意プロンプトに誰も答えない場合、Claude Code はプロンプトを閉じ、次のいずれかのメッセージでターンを終了します。

```text theme={null}
Fable limit reached · continuing on Fable 5.1 uses usage credits, and the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
Fable 5.1 now uses usage credits · the prompt to confirm went unanswered — nothing was sent · answer it where this session is running, or /model to change
```

メッセージはセッションの Fable モデルに名前を付けるため、Fable 5 では `continuing on Fable 5` と `Fable 5 now uses usage credits` と表示されます。v2.1.257 より前では、最初のメッセージは `Fable 5 limit reached` で始まりました。

これは [Remote Control](/docs/ja/remote-control) セッション、[background sessions](/docs/ja/agent-view)、および [agent team](/docs/ja/agent-teams) チームメイトセッションで発生します。Claude Code は同意プロンプトをセッション独自のインタラクティブビューにのみ表示します。実行されるターミナル、またはバックグラウンドセッションの場合は、アタッチしたら [agents view](/docs/ja/agent-view) です。Remote Control クライアントはそれを表示できません。Claude Code は [`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) デッドラインでプロンプトを閉じます。デフォルトは 5 分、またはセッションが実行されるターミナルで誰も入力していない間に新しいプロンプトが到着するとすぐに、Remote Control クライアントから送信されたプロンプトなどです。セッションが実行されるターミナルで入力するとデッドラインがキャンセルされ、Claude Code は回答を待ちます。バックグラウンドセッションのアタッチされたビューでは、入力はデッドラインをキャンセルせず、新しいプロンプトは同意プロンプトを閉じるため、どちらかが発生する前に回答してください。Claude Code は何も送信せず、モデルを保持するため、次のプロンプトを送信すると、Claude Code は同意プロンプトを再度表示します。

**対応方法：**

* セッションが実行されるターミナルで別のプロンプトを送信し、再度表示されたときに同意プロンプトに答えます。バックグラウンドセッションの場合は、最初に [agents view](/docs/ja/agent-view) からアタッチします。Remote Control クライアントから再送信すると、クライアントがプロンプトを表示できないため、このメッセージが再度表示されます。
* `/model` を実行して、使用クレジットを請求しないモデルに切り替えます
* そのターミナルに到達するまでの時間を増やすには、[`dialogExpiry`](/docs/ja/settings-reference#dialogexpiry) をより長い値または `"never"` に設定します

v2.1.236 より前では、このメッセージは表示されませんでした。Remote Control クライアントが接続されている間、Claude Code は回答を 60 秒待ってからデフォルトモデルでターンを続行しました。

<h3 id="server-is-temporarily-limiting-requests">
  Server is temporarily limiting requests
</h3>

API は、プランクォータとは無関係の短期的なスロットルを適用しました。

```text theme={null}
API Error: Server is temporarily limiting requests (not your usage limit)
```

Claude Code は、実際の制限応答が持つ統一クォータヘッダーの不在によって、これらをプラン制限と区別します。v2.1.199 以降、これは認証方法に関係なく、表示される前に [retried automatically](#automatic-retries) でバックオフされます。以前のバージョンでは、claude.ai サブスクリプションでサインインしたセッションは最初の発生時にターンに失敗しました。API キーと Enterprise サインインのみが再試行しました。

**対応方法：**

* 少し待ってから再度試してください
* 続く場合は [status.claude.com](https://status.claude.com) を確認してください

<h3 id="request-rejected-429">
  Request rejected (429)
</h3>

API キー、Amazon Bedrock プロジェクト、または Google Cloud プロジェクト用に設定されたレート制限に達しました。

```text theme={null}
API Error: Request rejected (429) · this may be a temporary capacity issue. If it persists, check https://status.claude.com.
```

末尾の文はサービスヘルスを確認する場所に名前を付け、プロバイダーによって異なります。Amazon Bedrock、Google Cloud の Agent Platform、および Microsoft Foundry 設定は、Anthropic ステータスページの代わりにそのプロバイダーのサービスステータスに名前を付けます。カスタム `ANTHROPIC_BASE_URL` はゲートウェイホストに名前を付けます。

**対応方法：**

* `/status` を実行し、アクティブな認証情報が予想されるものであることを確認します。環境内の迷走した `ANTHROPIC_API_KEY` は、サブスクリプションの代わりに低層キーを通じてリクエストをルーティングできます。
* プロバイダーコンソールでアクティブな制限を確認し、必要に応じてより高い層をリクエストします
* Anthropic API キーについては、[rate limits reference](https://platform.claude.com/docs/en/api/rate-limits) を参照して、層がどのように機能し、ワークスペースごとのキャップを設定する方法を確認してください
* 同時実行性を削減します。[`CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY`](/docs/ja/env-vars) を低くするか、多くの並列サブエージェントの実行を避けるか、高ボリュームのスクリプト実行用に `/model` で小さいモデルに切り替えます

<h3 id="spend-limit-reached">
  Spend limit reached
</h3>

[Claude apps gateway](/docs/ja/claude-apps-gateway) を通じて接続し、ゲートウェイオペレーターが設定した [spend cap](/docs/ja/claude-apps-gateway-spend-limits) を超えました。ゲートウェイは、指定された期間がリセットされるか、オペレーターがキャップを引き上げるまで、リクエストをブロックします。ブロックされた各 `429` レスポンスに `x-should-retry: false` とマークするため、Claude Code は再試行せずにこのメッセージを表示します。

```text theme={null}
spend limit reached (daily; resets 2026-08-09 00:00 UTC)
```

メッセージはキャップの期間とリセット時刻に名前を付け、オペレーターが `blocked_message` を設定した場合、その指示がそれに続きます。v2.1.225 より前では、メッセージは `spend limit reached` のみを読みました。古いバージョンのゲートウェイはまだその短い形式を送信します。

**対応方法：**

* メッセージが指定するリセット時刻まで待機するか、メッセージに指示が含まれている場合はそれに従います
* ルーチンでそれに達する場合は、ゲートウェイオペレーターにキャップを引き上げるよう依頼します

関連するメッセージ `spend limit unavailable` は、ゲートウェイが支出記録を読み取ることができず、キャップを超えるのではなく予防措置としてリクエストをブロックしたことを意味します。通常は自動的にクリアされます。続く場合は、ゲートウェイオペレーターに伝えてください。

<h3 id="credit-balance-is-too-low">
  Credit balance is too low
</h3>

Console 組織がプリペイドクレジットを使い果たしたか、Claude Code がサブスクリプションを使用する予定だったときに Console API キーでリクエストを送信しています。

```text theme={null}
Credit balance is too low
```

**対応方法：**

* Pro、Max、Team、または Enterprise プランを持っていてこれを見た場合は、`/status` を実行して `API key` 行を確認します。環境内の承認された `ANTHROPIC_API_KEY` は、サブスクリプションの代わりにそのキーを通じてリクエストをルーティングします。現在のシェルでそれをアンセットし、シェルプロファイルから削除してから、`claude` を再起動します。サブスクリプションでまだサインインしていない場合は `/login` を実行します。
* [platform.claude.com/settings/billing](https://platform.claude.com/settings/billing) でクレジットを追加し、そこで自動リロードを有効にして、ゼロに達する前に残高が補充されるようにすることを検討してください
* Console でワークスペースごとの支出キャップを設定して、単一のプロジェクトが組織残高を枯渇させるのを防ぎます。[Manage costs effectively](/docs/ja/costs) を参照してください。

<h3 id="could-not-update-your-spend-limit">
  Could not update your spend limit
</h3>

支出制限に達したときに表示されるプロンプトから行った支出制限の変更をサーバーが拒否しました。

```text theme={null}
Could not update your spend limit: <reason from the server>
```

サーバーが拒否を説明する場合、メッセージはその理由で終わり、同じ値を再試行すると再度失敗します。接続の切断など、失敗にサーバー提供の理由がない場合、メッセージは `Could not update your spend limit. Press Enter to retry.` と表示され、再試行は成功する可能性があります。v2.1.216 より前では、Claude Code はすべての失敗に対して汎用形式を表示していました。

**対応方法：**

* メッセージに理由が含まれている場合は、より低い金額など、それを満たす制限を選択します
* メッセージが汎用形式のみを表示する場合は、再試行します。失敗は一時的である可能性があります
* 変更が失敗し続ける場合は、ブラウザの [claude.ai billing settings](https://support.claude.com/en/articles/12429409-extra-usage-for-paid-claude-plans) から代わりに行います

<h2 id="authentication-errors">
  認証エラー
</h2>

これらのエラーは、Claude Code が API に対してあなたの身元を証明できないことを意味します。任意の時点で `/status` を実行して、現在アクティブな認証情報を確認してください。

<h3 id="not-logged-in">
  ログインしていない
</h3>

このセッションに有効な認証情報がありません。

```text theme={null}
Not logged in · Please run /login
```

**対応方法：**

* `/login` を実行して、Claude サブスクリプションまたは Console アカウントで認証してください
* 環境変数で認証されることを想定していた場合は、`ANTHROPIC_API_KEY` が `claude` を起動したシェルで設定およびエクスポートされていることを確認してください
* CI または自動化で対話的なログインが不可能な場合は、起動時にキーを取得する [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトを設定してください
* [認証の優先順位](/docs/ja/authentication#authentication-precedence) を参照して、複数の認証情報が存在する場合に Claude Code がどの認証情報を使用するかを理解してください

ログインを繰り返し求められる場合は、[ログインしていないまたはトークンの有効期限が切れている](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired) を参照して、システムクロックの確認と macOS 認証情報ストレージの復旧手順を確認してください。

<h3 id="could-not-resolve-authentication-method">
  認証方法を解決できませんでした
</h3>

セッションが認証情報なしで API クライアントに到達しました。[バックグラウンドセッション](/docs/ja/agent-view) とクラウドセッションは、ワーカーが認証情報なしで起動したときにこのメッセージを表示します。対話的、`-p`、および Agent SDK の実行は、[ログインしていない](#not-logged-in) と同じ条件を報告し、この文字列をデバッグログにのみ書き込みます。そこで見つけた場合は、代わりにそのエントリに従ってください。

```text theme={null}
Could not resolve authentication method. Expected one of apiKey, authToken, credentials, config, or profile to be set. Or for one of the "X-Api-Key" or "Authorization" headers to be explicitly omitted
```

現在のバージョンでは、エラーはワーカープロセスで利用可能な認証情報がなかったことを意味します。v2.1.174 より前では、アイドル状態の事前初期化されたワーカーに割り当てられたバックグラウンドセッションは、有効な認証情報が設定されていても、この方法で失敗する可能性がありました。v2.1.176 より前では、クレームされる前にアイドル状態だったクラウドセッションも同様でした。アップグレードして復旧してください。

**対応方法：**

* バックグラウンドまたはクラウドセッションに表示され、認証情報が既に設定されている場合は、v2.1.176 以降にアップグレードしてください
* `ANTHROPIC_API_KEY`、`CLAUDE_CODE_OAUTH_TOKEN`、またはクラウドプロバイダーの認証情報が、ワーカーを起動する環境で設定されていることを確認してください。対話的シェルだけではなく
* Agent SDK については、[クイックスタートの認証設定](/docs/ja/agent-sdk/quickstart#setup) を参照してください
* 同じ環境の対話的セッションで `/status` を実行して、どの認証情報ソースが解決されるかを確認してください

<h3 id="invalid-api-key">
  無効な API キー
</h3>

`ANTHROPIC_API_KEY` 環境変数または `apiKeyHelper` スクリプトが API に拒否されたキーを返しました。または Claude Code が `ANTHROPIC_API_KEY` からのキーを送信前にブロックしました。

```text theme={null}
Invalid API key · Fix external API key
```

メッセージが `Fix external API key` を超えて `Invalid X-Api-Key header value from ANTHROPIC_API_KEY: it contains a line break at character 41 (120 characters on 2 lines).` などの説明で続く場合、API はキーを見ていません。Claude Code は HTTP ヘッダーが運べない文字を見つけ、送信前にリクエストを停止しました。[無効なリクエストヘッダー値](#invalid-request-header-value) を参照して、説明を読み、値を修正する方法を確認してください。

**対応方法：**

* タイプミスがないか確認し、[Console](https://platform.claude.com/settings/keys) でキーが取り消されていないことを確認してください
* 同じシェルで `env | grep ANTHROPIC` を実行するか、PowerShell で `Get-ChildItem Env:ANTHROPIC*` を実行してください。direnv、dotenv シェルプラグイン、IDE ターミナルなどのツールは、明示的に設定しなくても、プロジェクト内の `.env` ファイルから古いキーをロードできます
* `ANTHROPIC_API_KEY` をアンセットして `/login` を実行し、代わりにサブスクリプション認証を使用してください
* キーが [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトから来ている場合は、スクリプトを直接実行して、stdout に有効なキーを出力することを確認してください
* `/status` を実行して、Claude Code が実際に使用している認証情報ソースを確認してください

<h3 id="your-apikeyhelper-script-is-failing">
  apiKeyHelper スクリプトが失敗しています
</h3>

Claude Code が [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) 設定のコマンドを実行しましたが、キーを取得できませんでした。キーがないと、リクエストはプレースホルダー認証情報で API に到達し、API は `401` で拒否します。ターミナルの `Authentication` パネルは、以下のいずれが発生したかを示します：

* コマンドがエラーで終了したか、タイムアウトしました
* コマンドが stdout に何も出力しませんでした
* コマンドがキー以外の何かを出力しました。ログインバナーやログ行など。パネルは `returned output that cannot be used as an API key` を表示し、何が間違っているかを示します。出力は繰り返しません。v2.1.227 より前では、Claude Code は周囲の空白をトリミングした後、コマンドが出力したものを送信していました。

```text theme={null}
Your apiKeyHelper script is failing · This usually means you need to re-authenticate with your provider · Run /status to see the script's error output
```

[非対話モード](/docs/ja/headless) では、stderr も特定の理由を `apiKeyHelper failed:` というプレフィックス付きで運びます。

Claude Code はスクリプトを再実行し、このメッセージを表示する前に最大 2 回までリクエストを再試行するため、失敗は 3 回の試行内に表面化します。v2.1.208 より前では、Claude Code は完全な [再試行予算](#automatic-retries) を費やしてプレースホルダー認証情報でリクエストを再送信し、スクリプト失敗の代わりに汎用 `401` 認証エラーを報告していました。

`/login` を実行しても役に立ちません。ヘルパーの出力は、設定が存在する限り、保存されたログインより [優先されます](/docs/ja/authentication#authentication-precedence)。

**対応方法：**

* `apiKeyHelper` で設定されたコマンドをシェルで直接実行して、失敗を再現してください
* コマンドが期限切れセッションを報告する場合は、SSO または秘密保管庫に再度サインインするなど、認証情報プロバイダーで再認証してください
* コマンドを修正して、stdout にのみキーを出力するようにしてください。単一のトークンとして、最大 16,384 文字の印字可能 ASCII で、終了コード 0 で。[apiKeyHelper で認証情報をローテーションする](/docs/ja/llm-gateway-connect#rotate-credentials-with-apikeyhelper) を参照して、動作するセットアップを確認してください
* `/status` を実行して、`apiKeyHelper` がアクティブな認証情報ソースであることを確認してください。コマンドが失敗するたびに、その終了コードとエラー出力がターミナルの `Authentication` パネルに表示されます。v2.1.212 より前では、パネルは `Cloud authentication` というタイトルでした。

<h3 id="invalid-request-header-value">
  無効なリクエストヘッダー値
</h3>

Claude Code がリクエストヘッダーとして送信しようとしていた値に、HTTP ヘッダーが運べない文字が含まれています。改行、NUL バイト、または `U+00FF` より上の文字（カーリークォートやゼロ幅スペースなど）。Claude Code はリクエストを停止し、修正する変数または設定を名前付けます。通常の原因は、見えない文字または迷走した改行を運んだドキュメントまたはチャットから貼り付けられた認証情報です。

Claude Code は Claude API に直接リクエストを送信するとき、または [LLM ゲートウェイ](/docs/ja/llm-gateway) を通じてリクエストを送信するときにこのチェックを実行します。[Amazon Bedrock](/docs/ja/amazon-bedrock) などのサードパーティクラウドプロバイダーでは、Claude Code は送信前にこれを実行しません。

```text theme={null}
Invalid auth token · Fix external auth token
Invalid ANTHROPIC_CUSTOM_HEADERS · Fix the environment variable
Invalid request header from the environment · Fix the environment variable
```

メッセージの最初の部分は、不正な値がどこから来たかによって異なります：

* `Invalid auth token`：[`ANTHROPIC_AUTH_TOKEN`](/docs/ja/env-vars) または [`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars) からのベアラートークン
* `Invalid ANTHROPIC_CUSTOM_HEADERS`：[`ANTHROPIC_CUSTOM_HEADERS`](/docs/ja/env-vars) で設定したヘッダー名または値。説明は、`distinct header 2 of 3 parsed from ANTHROPIC_CUSTOM_HEADERS` など、どの `Name: Value` ペアが問題かをカウントします。名前または値を繰り返さずに、両方を選択したため
* `Invalid request header from the environment`：Claude Code が別の環境変数（`CLAUDE_AGENT_SDK_CLIENT_APP` など）からリクエストヘッダーにコピーする値。説明は修正する変数を名前付けます。

Claude Code は、このチェックで検出された不正な `ANTHROPIC_API_KEY` を [無効な API キー](#invalid-api-key) として報告します。同じ末尾の説明付きで。保存された `/login` 認証情報の不正な値を [ログインしていない](#not-logged-in) として報告します。代わりに `/login` を実行して新しいものを保存してください。[`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) スクリプトの出力はこのチェックに到達しません。Claude Code はスクリプトが実行されるときに検証し、HTTP ヘッダーが運べない出力は [apiKeyHelper スクリプトが失敗しています](#your-apikeyhelper-script-is-failing) で失敗します。

2 番目の `·` の後、メッセージは問題を説明します。この完全な例のように：

```text theme={null}
Invalid auth token · Fix external auth token · Invalid Authorization header value from ANTHROPIC_AUTH_TOKEN: it contains a line break at character 41 (120 characters on 2 lines).
```

位置は 1 から始まる文字をカウントします。説明は固定フレーズと文字カウントから構築されるため、値自体は含まれません。バイト順マーク、ゼロ幅スペース、カーリークォートなど、よく知られている見えない文字または活字文字である場合にのみ、問題のある文字を名前付けます。その他は `a non-ASCII character` として報告します。

**対応方法：**

* メッセージが名前付けする変数または設定を再設定し、報告された位置の周囲の文字を再入力してください。同じソースから貼り付けないでください
* `ANTHROPIC_CUSTOM_HEADERS` の場合は、1 行に 1 つの `Name: Value` ペアを保持し、メッセージがカウントするペアを書き直してください
* `/status` を実行して、どの認証情報ソースがアクティブであるかを確認してください

<h3 id="this-organization-has-been-disabled">
  この組織は無効化されています
</h3>

Claude Code は、無効化された Console 組織からの古い `ANTHROPIC_API_KEY` を使用しています。保存されたサブスクリプションログインがある場合、キーはそれをオーバーライドします。

```text theme={null}
Your ANTHROPIC_API_KEY belongs to a disabled organization · Unset the environment variable to use your subscription instead
Your ANTHROPIC_API_KEY belongs to a disabled organization · Update or unset the environment variable
API Error: 400 ... This organization has been disabled.
```

`·` の後のヒントは、保存された認証情報によって異なります。最初の形式は、保存された `/login` がキーをアンセット後に引き継ぐことができるときに表示され、2 番目はキーが唯一の認証情報である場合に表示されます。

環境変数は `/login` より優先されるため、シェルプロファイルでエクスポートされたキーまたは `.env` ファイルからロードされたキーは、動作する Pro または Max サブスクリプションがある場合でも使用されます。非対話モード（`-p`）では、キーが存在する場合は常に使用されます。

**対応方法：**

* 現在のシェルで `ANTHROPIC_API_KEY` をアンセットし、シェルプロファイルから削除してから、`claude` を再起動してください
* メッセージが `Update or unset` と言う場合、フォールバックする保存されたログインがありません。キーをアンセットして `/login` を実行するか、アクティブな Console 組織からのキーに置き換えてください
* その後 `/status` を実行して、アクティブな認証情報がサブスクリプションであることを確認してください
* 環境変数が設定されておらず、エラーが続く場合、無効化された組織は `/login` に関連付けられたものです。サポートに連絡するか、別のアカウントでサインインしてください

<h3 id="your-organization-has-disabled-api-key-authentication">
  組織が API キー認証を無効化しました
</h3>

このメッセージには Claude Code v2.1.169 以降が必要です。Console 組織の管理者が API キー認証をオフにしたため、API は Claude Code が送信しているキーを拒否します。`·` の後の復旧ヒントは、キーがどこから来たかによって異なります：

```text theme={null}
Your organization has disabled API key authentication · Run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY to use your claude.ai account instead
Your organization has disabled API key authentication · Unset ANTHROPIC_API_KEY and run /login to sign in with your claude.ai account
Your organization has disabled API key authentication · Unset the apiKeyHelper setting and run /login to sign in with your claude.ai account
```

環境変数と `apiKeyHelper` は `/login` より優先されるため、どちらかがキーを供給している間は `/login` を実行するだけでは役に立ちません。[認証の優先順位](/docs/ja/authentication#authentication-precedence) を参照してください。

**対応方法：**

* メッセージが `ANTHROPIC_API_KEY` を名前付けする場合、現在のシェルでアンセットし、シェルプロファイルまたは `.env` ファイルから削除してから、`claude` を再起動してください
* メッセージが `apiKeyHelper` を名前付けする場合、`settings.json` から [`apiKeyHelper`](/docs/ja/settings-reference#apikeyhelper) 設定を削除してください
* `/login` を実行して claude.ai アカウントでサインインしてください
* その後 `/status` を実行して、アクティブな認証情報が API キーではなくサブスクリプションであることを確認してください
* 自動化に API キー認証が必要な場合は、組織管理者に Console で再度有効化するよう依頼してください

<h3 id="your-organization-has-disabled-claude-subscription-access">
  組織が Claude サブスクリプションアクセスを無効化しました
</h3>

Claude 組織は、Claude Code へのサブスクリプションログインでのサインインを許可していません。同じアカウントで `/login` を再度実行すると、同じエラーが返されます。

```text theme={null}
Your organization has disabled Claude subscription access for Claude Code · Use an Anthropic API key instead, or ask your admin to enable access
```

これはサーバー側の組織設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドできません。

Agent SDK と `-p` 非対話モードは、これを `oauth_org_not_allowed` エラーコードとして表面化します。

**対応方法：**

* 組織管理者に Claude Code アクセスを有効化するよう依頼してください
* サブスクリプションの代わりに Console API キーで認証してください。[Claude Console 認証](/docs/ja/authentication#claude-console-authentication) を参照してセットアップしてください
* あなたが管理者で、アクセスを有効化するオプションが表示されない場合は、[Anthropic サポート](https://support.claude.com) に連絡してください

<h3 id="routines-are-disabled-by-your-organizations-policy">
  ルーチンは組織のポリシーで無効化されています
</h3>

Team または Enterprise 組織の所有者がルーチンを組織レベルで無効化しました。エラーは、[Routines](/docs/ja/routines) UI on claude.ai/code からなど、ルーチンを作成または実行しようとするときに表示されます。Claude Code v2.1.227 以降では、同じ設定が CLI で [`/schedule` も非表示にします](/docs/ja/routines#troubleshooting)。

```text theme={null}
Routines are disabled by your organization's policy.
```

これはサーバー側の設定であるため、ローカル設定、環境変数、または CLI フラグからオーバーライドできません。

**対応方法：**

* 組織の所有者に [claude.ai/admin-settings/claude-code](https://claude.ai/admin-settings/claude-code) で **Routines** トグルを有効化するよう依頼してください
* 組織レベルのルーチンを必要としない 1 回限りのスケジュール作業については、[スケジュール済みタスク](/docs/ja/scheduled-tasks) を参照してください

<h3 id="remote-control-requires-the-anthropic-api">
  リモートコントロールは Anthropic API が必要です
</h3>

セッションが Anthropic API に直接通信していないため、[リモートコントロール](/docs/ja/remote-control) がペアリングする claude.ai バックエンドがありません。

```text theme={null}
Remote Control is only available when using Claude via api.anthropic.com. CLAUDE_CODE_USE_BEDROCK is set, so this session is using Amazon Bedrock — unset it (or run in a shell without it) to use Remote Control.
```

2 番目の文は、セッションを Anthropic API から遠ざけた原因を説明します。v2.1.219 より前は、メッセージは最初の文だけでした。原因によって、メッセージは以下を名前付けます：

* `CLAUDE_CODE_USE_*` プロバイダー変数。[Amazon Bedrock](/docs/ja/amazon-bedrock) の `CLAUDE_CODE_USE_BEDROCK` または [Google Cloud の Agent Platform](/docs/ja/google-vertex-ai) の `CLAUDE_CODE_USE_VERTEX` など
* [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が `api.anthropic.com` 以外のホストを指しています。[LLM ゲートウェイ](/docs/ja/llm-gateway) またはプロキシなど。claude.ai でサインインしている場合でも。v2.1.196 より前は、カスタムベース URL はリモートコントロールをブロックしませんでした
* エンタープライズ [クラウドゲートウェイ](/docs/ja/claude-apps-gateway) サインイン。`/login` を通じて行われ、リモートコントロールをサポートしておらず、アンセットする変数がありません

**対応方法：**

* メッセージが名前付けする変数（`CLAUDE_CODE_USE_BEDROCK` または `ANTHROPIC_BASE_URL` など）をアンセットし、セッションを再起動するか、Anthropic API に直接通信するセッションからリモートコントロールを開始してください
* 変数がシェルで設定されていない場合は、[設定ファイル](/docs/ja/settings#where-settings-live) の `env` キーを確認してください。これはすべてのセッションに環境変数を適用します
* このおよび他のリモートコントロール起動メッセージについては、[リモートコントロールのトラブルシューティング](/docs/ja/remote-control#troubleshooting) を参照してください

<h3 id="remote-control-couldnt-refresh-your-login">
  リモートコントロールがログインを更新できませんでした
</h3>

Claude Code は、保存された claude.ai ログインを使用して取得および更新する短命の認証情報で、ライブ [リモートコントロール](/docs/ja/remote-control) 接続を実行します。claude.ai がそのログインを受け入れなくなったとき、または Claude Code に保存されたログインが残っていないとき、Claude Code はリモートコントロールを停止し、再度サインインするよう求めます。どちらの失敗も Claude Code がまだ接続しているときに発生するか、後で認証情報を更新するときに発生する可能性があります。

Claude Code がログインサービスに保存されたログインを更新するよう要求し、応答がないとき、リモートコントロールを実行し続け、接続の現在の認証情報がまだ有効な間に更新を再試行します。更新が応答を得られないのは、Claude Code がログインサービスに到達できない、リクエストがタイムアウトする、またはサービスがログインを拒否せずに失敗するときです。その認証情報が期限切れになるときにログインサービスがまだ応答していない場合、Claude Code はリモートコントロールを停止し、`OAuth token refresh failed` を報告します。

Claude Code がリモートコントロールを停止するとき、警告とトランスクリプト行に理由を表示します。トランスクリプト行は `Remote Control disconnected` で始まります。ローカルセッションはリモートコントロールなしで実行し続けます。このセクションはこれらの行をカバーしています：

```text theme={null}
Remote Control disconnected — Claude.ai login expired — run /login to restore Remote Control
Remote Control disconnected — Claude.ai login expired — run /login, then /remote-control
Remote Control disconnected — Claude.ai login was rejected — run /login, then /remote-control
Remote Control disconnected — OAuth token unavailable — run /login to restore Remote Control
Remote Control disconnected — OAuth token refresh failed — run /login to re-authenticate
Remote Control disconnected — JWT refresh failed: no OAuth token — run /login
Remote Control disconnected — Signed out of Claude — run /login, then /remote-control
```

Claude Code はメッセージの中央に原因を名前付けます：

* ` Claude.ai login expired` および `Claude.ai login was rejected`：claude.ai はもはや保存されたログイントークンを受け入れません。期限切れまたは取り消されたため
* ` OAuth token unavailable`：Claude Code は接続の認証情報が更新期限に来たときに保存されたログイントークンを持っていませんでした
* ` OAuth token refresh failed`：claude.ai は Claude Code が再接続しているときに保存されたログイントークンを拒否し、トークンを更新しても新しいものが生成されませんでした
* ` JWT refresh failed: no OAuth token`：Claude Code は保存されたログイントークンを更新するために見つけられませんでした
* ` Signed out of Claude`：別のターミナルで `/logout` を実行するなど、このマシンで署名を解除したため、Claude Code は接続を更新するために保存されたログインが残っていません

**対応方法：**

* `/login` を実行して再度サインインしてください
* `/remote-control` を実行してセッションを再接続してください。` run /login to restore Remote Control` で終わるメッセージはこのステップを必要としません。Claude Code はサインイン後に自動的に再接続します。

v2.1.224 より前は、`OAuth token refresh failed — run /login to re-authenticate` は `OAuth token refresh failed — re-authenticate, then re-enable Remote Control` と読み、`JWT refresh failed: no OAuth token — run /login` は `no OAuth token available for recovery (code <N>)` と読みました。` Claude.ai login expired`、`Claude.ai login was rejected`、および `OAuth token unavailable` メッセージは v2.1.225 で追加されました。

v2.1.238 より前は、Claude Code は現在 `Signed out of Claude` と言うケースを `JWT refresh failed: no OAuth token — run /login` として報告し、1 つのログイン更新が応答を得られないとすぐに `Claude.ai login expired — run /login to restore Remote Control` でリモートコントロールを停止しました。

<h3 id="remote-control-stopped-because-the-signed-in-account-changed">
  サインイン済みアカウントが変更されたため、リモートコントロールが停止しました
</h3>

Claude Code は、このマシンで別の claude.ai アカウントまたは組織にサインインしたときに、[リモートコントロール](/docs/ja/remote-control) セッション中にこの行を表示します。別のターミナルで `/login` を実行するなど、Claude Code セッションの外でスイッチを行いました。

サインイン時に `/login` を通じて開始したリモートコントロールセッションは、その時点でサインインしていた claude.ai アカウントと組織に属しています。

```text theme={null}
Remote Control disconnected — signed-in claude.ai account or organization changed on this machine — run /remote-control to start a session for the current account, or /login to switch back, then /remote-control
```

Claude Code は、claude.ai がアカウントまたは組織の変更を確認するとすぐにリモートコントロールセッションを停止します。ローカルセッションはリモートコントロールなしで実行し続けます。

**対応方法：**

* `/remote-control` を実行して、現在のアカウントまたは組織の下で新しいリモートコントロールセッションを開始してください
* 戻すには、`/login` を実行して前のアカウントまたは組織に再度サインインしてください。その後 `/remote-control` を実行してください。

v2.1.234 より前は、Claude Code は Claude Code セッションの外でアカウントまたは組織を切り替えたときに気付きませんでした。Claude Code はリモートコントロールセッションを接続したままにしておき、後でリモートコントロールサーバーへのリクエストが `Remote Control server rejected the request (HTTP 404)` で失敗するまで。その失敗はスイッチの数時間後に来る可能性がありました。

<h3 id="remote-control-stopped-because-the-app-running-the-session-signed-out-or-switched-accounts">
  セッションを実行しているアプリが署名を解除したか、アカウントを切り替えたため、リモートコントロールが停止しました
</h3>

Claude デスクトップアプリまたは IDE がセッションをホストしている場合、Claude Code は `/login` ではなくそのアプリからログイントークンを取得します。claude.ai がそのトークンを拒否するとき、Claude Code はアプリに新しいものを要求します。アプリが署名を解除したこと、または別の Claude アカウントにサインインしたことを答える場合、Claude Code は [リモートコントロール](/docs/ja/remote-control) セッションを終了し、アプリにこれらの行のいずれかを送信します：

```text theme={null}
Remote Control stopped — the app running this session is now signed in to a different Claude account
Remote Control stopped — the app running this session is signed out of Claude. Sign in there, then turn Remote Control back on
```

ローカルセッションはリモートコントロールなしで実行し続けます。

**対応方法：**

* アプリが署名を解除している場合は、再度サインインしてから、リモートコントロールを再度オンにしてください
* アプリがアカウントを切り替えた場合、Claude Code は終了したセッションを新しいアカウントの下で続行できません。そのアカウントの下で新しいリモートコントロールセッションを開始してください。

v2.1.238 より前は、Claude Code は両方のケースでアプリに [リモートコントロールがログインを更新できませんでした](#remote-control-couldnt-refresh-your-login) の下にリストされている `run /login` メッセージを送信していました。

<h3 id="oauth-token-revoked-or-expired">
  OAuth トークンが取り消されたか、期限切れです
</h3>

保存されたログインはもはや有効ではありません。取り消されたトークンはどこでも署名を解除したか、管理者がアクセスを削除したことを意味します。期限切れトークンは自動更新がセッション中に失敗したことを意味します。

両方のメッセージは、Claude Code が送信したリクエストに対して API が返した拒否を報告します。保存されたログインが失敗した更新後に既にクリアされている場合、代わりに [ログイン期限切れ](#login-expired) が表示されます。[`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars) で長命トークンで認証する場合、そのトークンが期限切れまたは取り消されたときに同じメッセージが表示されます。

```text theme={null}
OAuth token revoked · Please run /login
OAuth token has expired · Please run /login
API Error: 401 ... authentication_error
```

**対応方法：**

* `/login` を実行して再度サインインしてください
* エラーが再認証後の同じセッション内で返される場合は、最初に `/logout` を実行して保存されたトークンを完全にクリアしてから、`/login` を実行してください
* ` CLAUDE_CODE_OAUTH_TOKEN` 環境変数で認証する場合、Claude Code はリクエストが 401 で失敗した後、保存されたログインのトークンに切り替えるのではなく、設定した値を送信し続けます。[`/status`](/docs/ja/commands) はこの認証情報を `Auth token` 行として表示し、`CLAUDE_CODE_OAUTH_TOKEN` を読みます。[`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で新しいトークンを生成し、それで再起動するか、変数をアンセットして `/login` を実行してください。v2.1.225 より前は、Claude Code はセッション中に変数の値を保存されたログインからの短命アクセストークンに置き換える可能性があり、そのトークンが期限切れになると、セッションは再び 401 エラーで失敗しました。
* ログイン全体で繰り返されるプロンプトについては、[トラブルシューティング](/docs/ja/troubleshoot-install#not-logged-in-or-token-expired) のシステムクロック確認と macOS 認証情報ストレージ復旧手順を参照してください
* `403 Forbidden` および OAuth ブラウザーの問題を含む他の失敗については、[ログインと認証](/docs/ja/troubleshoot-install#login-and-authentication) を参照してください

<h3 id="api-error-401-invalid-authentication-credentials">
  API エラー：401 無効な認証認証情報
</h3>

API は認証情報の形式を認識しましたが、その背後にあるアカウントまたは組織を拒否しました。Anthropic は、認証情報が最近取り消されたとき、組織が無効化されたか、アクセスを削除したとき、またはアカウント自体が無効化されたときにこのメッセージを返すため、期限切れトークンは原因ではありません。認証情報は保存されたログインまたは承認された `ANTHROPIC_API_KEY` である可能性があり、修正は異なるため、`/status` を実行してどちらがアクティブであるかを確認することから始めてください。

```text theme={null}
Please run /login · API Error: 401 Invalid authentication credentials
```

**対応方法：**

* `/status` が `API key` 行を表示する場合、承認された [`ANTHROPIC_API_KEY`](/docs/ja/authentication#authentication-precedence) がアクティブな認証情報であり、ログインより優先されるため、`/login` はそれを置き換えません。Claude Console でキーをローテーションするか、`unset ANTHROPIC_API_KEY` を実行するか、PowerShell で `Remove-Item Env:ANTHROPIC_API_KEY` を実行してサブスクリプションにフォールバックしてください。
* `/status` がログインのみを表示する場合、`/login` を 1 回実行してください。認証情報が取り消された場合、新しいログインがそれを置き換えます。
* 同じログインアカウントに対して同じメッセージが返される場合、アカウントまたは組織はもはやアクティブではありません。`/status` が報告するアカウントと組織を確認し、組織管理者にアクセスを復元するよう依頼してください。
* [`ANTHROPIC_BASE_URL`](/docs/ja/env-vars) が [LLM ゲートウェイ](/docs/ja/llm-gateway) を指している場合、`401` の後のテキストは Anthropic のメッセージではなくゲートウェイのメッセージであり、`/login` はそれを変更しません。代わりにゲートウェイが期待する認証情報を修正してください。

<h3 id="login-expired">
  ログイン期限切れ
</h3>

Claude Code は保存された claude.ai または Claude Console ログインを更新しようとし、OAuth サービスは保存されたリフレッシュトークンを拒否したため、Claude Code は保存された認証情報をクリアしました。その後、各モデルリクエストは API に到達する前にこのメッセージでローカルに停止します。`/login` だけが新しい認証情報を作成できるため。

v2.1.206 より前は、Claude Code はモデルリクエストを環境に残っている認証情報で送信し、すべてのモデルは [選択されたモデルに問題があります](#theres-an-issue-with-the-selected-model) または 401 で失敗し、サインインを求めるプロンプトの代わりに失敗しました。

```text theme={null}
Login expired · Please run /login
```

[非対話モード](/docs/ja/headless)（`-p`）および [Agent SDK](/docs/ja/agent-sdk/overview) では、メッセージは以下のように読み、構造化エラーコードは `authentication_failed` です：

```text theme={null}
Failed to authenticate: OAuth session expired and could not be refreshed
```

これは [OAuth トークンが取り消されたか、期限切れです](#oauth-token-revoked-or-expired) と同じ状態ではありません。これらのメッセージは API が返した 401 を報告します。Claude Code 自体は既に更新に失敗したログインに対して `Login expired` を生成するため、リクエストを送信しません。更新がトークンが古いのではなくアカウント自体が中断されたために失敗する場合、Claude Code は代わりに [アカウントが保留中です](#your-account-is-on-hold) を表示します。

API キー、[`CLAUDE_CODE_OAUTH_TOKEN`](/docs/ja/env-vars)、またはサードパーティプロバイダーで認証されたセッションは保存されたログインを使用せず、このメッセージを見ることはありません。

リクエストが失敗する前にこの状態を確認できます。[`/status`](/docs/ja/commands) は `Login` 行を表示し、`Expired — log in again` を読み、期限切れログインに対して保存された組織とメールを加えます。行は保存されたログインがアクティブな認証情報であり、もはや更新できない場合にのみ表示されます。別の方法で認証されたセッションは、期限切れログインが保存されたままであっても、行を表示しません。v2.1.210 より前は、`/status` はこの状態で、クリアされた認証情報がそれを報告するものが何もなかったため、ログインが存在したことを示していませんでした。

**対応方法：**

* `/login` を実行して再度サインインしてください。サインインせずに再試行すると、すべてのリクエストで同じメッセージが表示されます。
* 非対話モードでは、同じ環境で `claude` を実行し、`/login` を完了してから、コマンドを再実行してください。対話的にサインインできない自動化については、`ANTHROPIC_API_KEY` で認証するか、[`claude setup-token`](/docs/ja/authentication#generate-a-long-lived-token) で長命トークンを生成してください。
* サインインが失敗し続ける場合は、[ログインと認証](/docs/ja/troubleshoot-install#login-and-authentication) を参照してください

<h3 id="your-account-is-on-hold">
  アカウントが保留中です
</h3>

ログインの背後にある Claude アカウントが中断されています。Claude Code は最初のメッセージを保存されたログインを更新しようとして保留を学ぶときに表示し、2 番目をブラウザーで完了したサインインが報告するときに表示します：

```text theme={null}
Your account is on hold and can't use Claude Code. View details or appeal: https://claude.ai/restricted
Your account is on hold and can't sign in to Claude Code. View details or appeal: https://claude.ai/restricted
```

同じアカウントで再度サインインしても、メッセージはクリアされません。保留はアカウントにあり、ログインではなく。[非対話モード](/docs/ja/headless)（`-p`）および [Agent SDK](/docs/ja/agent-sdk/overview) では、構造化エラーコードは `account_on_hold` です。v2.1.235 より前は、Claude Code は保留中のアカウントを [ログイン期限切れ · /login を実行してください](#login-expired) として報告し、その復旧手順は保留をクリアできません。

**対応方法：**

* メッセージのリンクを開いて、保留の詳細を表示するか、それに異議を唱えてください
* 保留の影響を受けない別の Claude アカウントまたは API キーがある場合、保留が解決されている間、作業を続けることができます。そのアカウントで `/login` を実行するか、`ANTHROPIC_API_KEY` でキーを設定してください

<h3 id="anthropic-profile-login-expired">
  Anthropic プロファイルログイン期限切れ
</h3>

Claude Code は、保存されたログイン認証情報が期限切れになった Anthropic 認証情報プロファイルを通じて認証しており、プロファイルは Claude Code が更新するために使用できるリフレッシュ認証情報を保持していません。Claude Code は、同じ期限切れ認証情報を読むため、リトライなしで各リクエストをローカルで停止します。

```text theme={null}
Anthropic profile login expired · Re-authenticate your Anthropic profile
Anthropic profile login expired · Run /login to use your claude.ai account instead, or re-authenticate the profile
```

これは、アクティブな認証情報が Anthropic 認証情報プロファイルから来ている場合にのみ表示されます。`ANTHROPIC_PROFILE` 環境変数で選択するもの、Claude Code が Anthropic 設定ディレクトリでアクティブなプロファイルとして発見するもの、または Claude Code が [API キーなしでサインイン](/docs/ja/authentication#sign-in-without-an-api-key) したときに書き込むもの。`/login` の claude.ai オプション、API キー、`ANTHROPIC_AUTH_TOKEN` などのベアラートークン、またはサードパーティプロバイダーで認証するセッションは、このメッセージを見ることはありません。

キーレスサインインを [提供する](/docs/ja/authentication#sign-in-without-an-api-key) マシンでは、`/login` を実行し、Anthropic Console アカウントを選択して、プロファイルを更新するために再度サインインしてください。キーレス Console サインインまたは Claude Platform CLI の `ant auth login` が書き込んだもの。Claude Code はそのプロファイルの期限切れ認証情報を置き換えます。フェデレーションプロファイルまたは別のツールが作成したもの、`/login` は認証情報を更新しません。表示されるフォームは、プロファイルを選択したか、Claude Code が発見したかによって異なります：

* `ANTHROPIC_PROFILE` を明示的に設定した場合、メッセージは `Re-authenticate your Anthropic profile` で終わります。
* Claude Code が設定ディレクトリからプロファイルを発見した場合、メッセージは `/login` を提供します。Claude Code は動作する `/login` を発見されたプロファイルより優先し、代わりに claude.ai または Console アカウントで認証するため。v2.1.234 より前は、Claude Code はこのケースでも `Re-authenticate your Anthropic profile` フォームを表示していました。

**対応方法：**

* プロファイルに再度サインインしてから、再試行してください。キーレスサインインを [提供する](/docs/ja/authentication#sign-in-without-an-api-key) マシンでは、`/login` を実行し、キーレス Console サインインまたは Claude Platform CLI の `ant auth login` が書き込んだプロファイルの Anthropic Console アカウントを選択してください。他のプロファイルについては、それらを作成したツールを使用してください
* 管理者がプロファイルの認証情報をプロビジョニングした場合は、新しいものを発行するよう依頼してください
* `/status` を実行してアクティブな認証情報ソースとプロファイル名を確認してください
* プロファイルの使用を停止するには、設定した場合は `ANTHROPIC_PROFILE` をアンセットし、`/login` または `ANTHROPIC_API_KEY` などの別の方法で認証してください

<h3 id="oauth-scope-requirement">
  OAuth スコープ要件
</h3>

保存されたトークンは、新しい機能が必要とする権限スコープより前のものです。`/usage` とステータス行の使用インジケーターから最も頻繁にこれが表示されます：

```text theme={null}
OAuth token does not meet scope requirement: user:profile
```

**対応方法：**

* `/login` を実行して、現在のスコープで新しいトークンを取得してください。最初にログアウトする必要はありません。

<h3 id="claude-ai-rejected-the-session-token">
  claude.ai がセッショントークンを拒否しました
</h3>

[claude.ai コネクター](/docs/ja/mcp#use-mcp-servers-from-claude-ai) リクエストが失敗しました。claude.ai が Claude Code ログインからのトークンを拒否したため。通常、期限切れになり、更新できなかったログイン。拒否されたトークンはコネクターのログイン、コネクターの claude.ai での独自の認可ではないため、コネクターを再度認可してもそれは解決しません。`/mcp` では、コネクターは `connected · session token rejected` として表示され、その詳細ビューは以下のように読みます：

```text theme={null}
claude.ai rejected the session token. Run /login, then reconnect.
```

**対応方法：**

* `/login` を実行して再度サインインしてください
* `/mcp` からコネクターを再接続するか、`/mcp reconnect <server>` を実行してください。再度サインインする前に再接続すると、コネクターは同じ状態のままになります。`/mcp` パネルの **Reconnect** オプションは `your claude.ai session token was rejected` を報告します。入力された `/mcp reconnect <server>` フォームは、トークンがまだ拒否されていても、成功した再接続を報告します。

v2.1.222 より前は、Claude Code はコネクターを認証が必要として標記し、完了してもそれが状態を解決しなかったにもかかわらず、コネクターの認可フローを指しました。

<h3 id="issuer-mismatch-in-authorization-response">
  認可応答の発行者の不一致
</h3>

[MCP OAuth サインイン](/docs/ja/mcp#authenticate-with-remote-mcp-servers) 中に、認可サーバーは Claude Code に `iss` パラメーターでリダイレクトバックしました。これは Claude Code がサーバーの OAuth メタデータから期待していた発行者を名前付けしません。このステップでの間違った発行者は、認可サーバーの混合攻撃がどのように見えるかであるため、Claude Code は認可コードを交換する代わりにサインインに失敗します。Claude Code はブラウザーサインイン後の `/mcp` サーバーメニューにエラーを表示します：

```text theme={null}
Issuer mismatch in authorization response (RFC 9207): expected "https://auth.example.com", received "https://other.example.com"
```

`expected` はサーバーの OAuth メタデータからの発行者であり、`received` はリダイレクトが運んだ `iss` 値です。`iss` パラメーターを運ばないサインインは、サーバーのメタデータが `authorization_response_iss_parameter_supported` を設定しない限り、チェックに合格します。その場合、Claude Code はサインインに失敗します。

**対応方法：**

* `/mcp` からサインインを再度試してください
* エラーが繰り返される場合は、サーバーオペレーターに報告してください。修正はサーバー側です。認可サーバーは、メタデータで宣伝する同じ発行者を `iss` パラメーターで返す必要があります
* サーバーが修正されている間に接続するには、[`MCP_SDK_GENERATION=v1`](/docs/ja/env-vars) で Claude Code を開始してください。その [ランタイム](/docs/ja/mcp#mcp-client-runtimes) はこのチェックを実行しません。これは混合攻撃に対する保護を削除するため、サーバー側の修正を優先してください

v2.1.232 より前は、Claude Code は段階的なロールアウトでのみ v2 ランタイムを使用するか、`MCP_SDK_GENERATION=v2` を設定したときに使用していました。

<h3 id="aws-credentials-expired-or-invalid">
  AWS 認証情報が期限切れまたは無効です
</h3>

このメッセージには Claude Code v2.1.198 以降が必要で、[`awsAuthRefresh`](/docs/ja/amazon-bedrock#advanced-credential-configuration) が設定ファイルで設定されている場合にのみ表示されます。AWS セッショントークンが期限切れになったか、拒否されました。Claude Code が既に実行した自動更新は、API が受け入れる認証情報を生成しませんでした。[Claude Platform on AWS](/docs/ja/claude-platform-on-aws) または [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) からの 401 に表示されます。これらのプロバイダーが期限切れセキュリティトークンを報告する方法です。

中央のアクション ヒントは設定ファイルの `awsAuthRefresh` コマンドを名前付けするため、異なります。安定した部分は先頭の `AWS credentials expired or invalid` です：

```text theme={null}
AWS credentials expired or invalid · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · API Error: 401 ...
```

`awsAuthRefresh` が設定されていない場合、同じ 401 は代わりに汎用 `Please run /login` メッセージを表示し、AWS 認証情報を更新できません。

**対応方法：**

* メッセージで名前付けされた `awsAuthRefresh` コマンド（`aws sso login --profile myprofile` など）を別のターミナルで実行し、ブラウザーサインインを完了してから、再試行してください
* 対話的セッションでは、`/login` を実行し、**3rd-party platform** を選択してから、**Using 3rd-party platforms** の下で **Claude Platform on AWS · refresh credentials** を選択して、Claude Code を再起動せずに同じコマンドを実行してください。[AWS 認証情報を設定する](/docs/ja/claude-platform-on-aws#1-configure-aws-credentials) を参照してください
* 更新コマンドが成功した後もエラーが繰り返される場合は、同じシェルとプロファイルで `aws sts get-caller-identity` を使用して Claude Code の外で ID が有効であることを確認してください

<h3 id="aws-authentication-failed">
  AWS 認証が失敗しました
</h3>

このメッセージには Claude Code v2.1.198 以降が必要で、[`awsAuthRefresh`](/docs/ja/amazon-bedrock#advanced-credential-configuration) が設定ファイルで設定されている場合にのみ表示されます。AWS プロバイダーが 403 を返したか、[Amazon Bedrock](/docs/ja/amazon-bedrock) が 401 を返しました。

Claude Code はどちらの原因に当たったかを判断できません。Amazon Bedrock は期限切れセキュリティトークンを 403 として報告しますが、403 は認可拒否（IAM 権限の欠落またはアカウントで有効化されていないモデルなど、`AccessDeniedException` など）を報告する方法でもあります。

Amazon Bedrock からの 401 も [AWS 認証情報が期限切れまたは無効です](#aws-credentials-expired-or-invalid) の下ではなくここに着地します。Amazon Bedrock はそのエンドポイントから期限切れトークンを 401 として報告しないため。そのエンドポイントからの 401 は通常、リクエストパスの他の何か（企業プロキシなど）から来ます。

認証情報更新は期限切れトークンを修正し、他の原因を修正できないため、メッセージは両方を提供します：

```text theme={null}
AWS authentication failed · run /login and select "Claude Platform on AWS · refresh credentials", or run `aws sso login --profile myprofile` in another terminal · if credentials are current, check AWS permissions and model access · API Error: 403 ...
```

中央のアクション ヒントは設定ファイルの `awsAuthRefresh` コマンドを名前付けするため、異なります。安定した部分は先頭の `AWS authentication failed` です。

**対応方法：**

* メッセージで名前付けされた `awsAuthRefresh` コマンドを実行するか、`aws sso login` を実行してください。期限切れ認証情報が原因である場合に備えて
* 認証情報が現在の場合は、[IAM 設定](/docs/ja/amazon-bedrock#iam-configuration) の IAM 権限が使用している ID に接続されていることを確認し、選択されたモデルがアカウントとリージョンで有効化されていることを確認してください
* `aws sts get-caller-identity` を実行して、リクエストがどの ID を使用するかを確認してください。古い `AWS_PROFILE` またはデフォルトプロファイルは、権限の不一致の一般的な原因です

<h3 id="aws-default-chain-credential-resolve-timed-out">
  AWS デフォルトチェーン認証情報解決がタイムアウトしました
</h3>

AWS デフォルト認証情報プロバイダーチェーンは 60 秒以内に認証情報を生成しなかったため、Claude Code は解決を停止し、リクエストに失敗しました。失敗はローカル認証情報解決です。リクエストは [Amazon Bedrock](/docs/ja/amazon-bedrock)、[Claude Platform on AWS](/docs/ja/claude-platform-on-aws)、または [Mantle エンドポイント](/docs/ja/amazon-bedrock#use-the-mantle-endpoint) に到達しませんでした。Claude Code はこのエラーが表面化する前に [認証情報キャッシュ](/docs/ja/amazon-bedrock#credential-caching-and-resolution-timeout) をクリアして再試行するため、このメッセージが表示されるまでにチェーンは繰り返された試行でスタールしています。

```text theme={null}
API Error: AWS default-chain credential resolve timed out
```

一般的な原因は、AWS プロファイルの `credential_process` コマンドが受け取ることができない入力を待機し、インスタンスメタデータサービス（IMDS）がチェーンのプローブに応答しないコンテナまたは VM です。v2.1.207 より前は、スタールしたチェーンはリクエストを無期限に待機させ、このメッセージで失敗する代わりに失敗しました。

**対応方法：**

* 同じシェルで同じ `AWS_PROFILE` で `aws sts get-caller-identity` を実行してください。それもハングする場合は、プロファイルを修正してください。対話的にプロンプトを表示する `credential_process` コマンドは一般的な原因です。
* Claude Code を開始する前にサインインステップを完了してください。例えば `aws sso login --profile myprofile`。チェーンはブラウザーフローを待機する代わりにローカル SSO キャッシュから解決するため
* チェーンが `aws-vault` などのラッパーを使用した MFA を使用した SSO などの正当に 60 秒以上を必要とする対話的サインインを実行する場合は、ミリ秒単位で [`CLAUDE_CODE_AWS_CHAIN_RESOLVE_TIMEOUT_MS`](/docs/ja/env-vars) で制限を上げてください

<h3 id="cloud-gateway-session-expired">
  クラウドゲートウェイセッション期限切れ
</h3>

[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway) を通じてサインインし、このマシンに保存されたゲートウェイセッションが期限切れになり、更新できなかったか、ゲートウェイはそれを受け入れなくなりました。例えば、ゲートウェイの [JWT シークレットが置き換えられた](/docs/ja/claude-apps-gateway-deploy#jwt-secret-rotation) 後。`claude` を対話的に開始するときにこの行が表示される場合、セッションはゲートウェイから署名を解除して開いています：

```text theme={null}
Cloud gateway session expired — run /login to reconnect.
```

同じ行はセッション中に表示される可能性があります。ゲートウェイ認証情報が期限切れになり、Claude Code が更新できない場合。

[非対話的](/docs/ja/headless) 実行、バックグラウンドまたは他の無人セッション、または `claude auth` 以外の `claude` サブコマンドでは、Claude Code はゲートウェイがセッションを受け入れなくなったときに代わりにこのメッセージで終了します：

```text theme={null}
Cloud gateway <url> no longer accepts this session. Start `claude` and sign in again with /login.
```

**対応方法：**

* セッションで `/login` を実行し、ブラウザーサインインを完了してください
* 非対話的な起動の場合は、同じ環境で `claude` を開始し、`/login` を実行してから、コマンドを再実行してください

<h2 id="network-and-connection-errors">
  ネットワークと接続エラー
</h2>

これらのエラーのほとんどは、Claude Code からのネットワークリクエストが宛先に到達できなかったか、Claude Code と API の間で何かが戻りの応答を変更したことを意味します。ローカルアーカイブ書き込みの失敗など、ローカルの原因がある場合、その本文に記載されています。通常、ローカルネットワーク、プロキシ、ファイアウォール、またはクラウド環境のネットワークポリシーで発生します。

<h3 id="unable-to-connect-to-api">
  API に接続できません
</h3>

API への TCP 接続が失敗したか、完了しませんでした。一般的な接続エラーコードについては、メッセージは失敗の種類を示し、括弧内にコードを保持します。

```text theme={null}
Unable to connect to API. Check your internet connection
Connection refused — a firewall or proxy may be blocking it (ConnectionRefused)
Can't reach the API server — check your internet or DNS (ENOTFOUND)
No internet route — check your connection or VPN (EHOSTUNREACH)
Couldn't connect through your proxy (ERR_PROXY_TUNNEL)
Connection dropped (ECONNRESET)
fetch failed
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

* Linux と WSL では、`/etc/resolv.conf` で到達不可能なネームサーバーを確認してください。特に WSL はホストから壊れたリゾルバーを継承できます。
* macOS では、切断またはアンインストールされた VPN クライアントがトンネルインターフェイスまたはルーティングルールを残す可能性があります。`ifconfig` で古い `utun` インターフェイスを確認し、システム設定で VPN のネットワーク拡張機能を削除してください。
* Docker Desktop および同様のコンテナランタイムは、アウトバウンドトラフィックをインターセプトできます。これを除外するために、それらを終了して再試行してください。

<h3 id="unable-to-connect-to-anthropic-services">
  Anthropic サービスに接続できません
</h3>

初回実行セットアップ中に、Claude Code はサインインステップを表示する前に `api.anthropic.com` と `platform.claude.com` に到達できることを確認します。いずれかのチェックが失敗すると、Claude Code は理由を出力して終了します。

```text theme={null}
Unable to connect to Anthropic services
Failed to connect to api.anthropic.com: ECONNREFUSED
Connection to api.anthropic.com timed out after 10 seconds
A proxy is configured via HTTPS_PROXY. Check that it allows connections to the host above.
```

Claude Code は、API リクエストと同じ [プロキシ設定](/docs/ja/network-config) を通じてチェックを送信し、各プローブに 10 秒を与えます。失敗したプローブがプロキシを通過した場合、メッセージは `HTTPS_PROXY` などの環境変数を名前で指定します。v2.1.222 より前では、チェックはタイムアウトなしの異なるプロキシトランスポートを使用していました。`https://` スキーム付きのプロキシ URL の背後では、`Checking connectivity...` で無期限に停止してから失敗する可能性があり、同じプロキシを通じた API リクエストが成功しても失敗します。

Claude Code は、[管理設定ファイル、MDM ポリシー、またはポリシーヘルパー](/docs/ja/managed-settings) が [`forceLoginMethod`](/docs/ja/settings-reference#forceloginmethod) を `"gateway"` に設定するか、`forceLoginMethod` なしで [`forceLoginGatewayUrl`](/docs/ja/settings-reference#forcelogingatewayurl) を設定する場合、このチェックをスキップします。どちらかの設定では、Claude Code は **Cloud gateway** 画面ではなく Anthropic サインイン方法でサインインステップを開きます。マシン上の管理設定ソースが存在するが読み取れない場合、Claude Code はチェックをスキップします。そのソースはゲートウェイ設定を保持する可能性があるためです。v2.1.247 より前では、Claude Code はこの設定下でもチェックを実行し、Anthropic のエンドポイントに到達できない場合、このエラーで終了しました。

**対応方法：**

* メッセージがプロキシ変数を名前で指定する場合、その値が正しいプロキシを指しており、ネットワークチームにメッセージ内のホストへの HTTPS 接続を許可するよう依頼してください。[ネットワーク設定](/docs/ja/network-config) を参照してください。
* [API に接続できません](#unable-to-connect-to-api) のチェックを実行してください。そこの `curl` テストとファイアウォールガイダンスはこのチェックにも適用されます。
* 組織が [クラウドゲートウェイ](/docs/ja/claude-apps-gateway) を通じてサインインし、このエラーが初回実行時に表示される場合は、Claude Code v2.1.247 以降に更新してください。
* ネットワークが開いており、障害が続く場合、Claude Code は [お客様の国で利用できない](https://www.anthropic.com/supported-countries) 可能性があります。

<h3 id="socket-is-closed">
  ソケットが閉じられています
</h3>

`Socket is closed` は、ストリーミング応答を運ぶ接続が応答がまだ到着している間に閉じられたことを意味します。最も一般的な原因は、Windows 上の企業プロキシが確立されたトンネルを応答の途中でドロップすることです。

応答がどこまで進んだかに応じて、Claude Code は要求を再試行し、Claude が生成したものを保持するか、ターンを終了します。[自動再試行](#automatic-retries) を参照してください。

v2.1.214 より前では、Claude Code はこの障害を再試行せず、ターンは `Socket is closed` を含むエラーで停止しました。

**対応方法：**

* このエラーが表示される場合は、`claude update` で v2.1.214 以降に更新してから、メッセージを再度送信してください。
* 更新後も同じプロキシの背後でターンが失敗し続ける場合は、[API に接続できません](#unable-to-connect-to-api) を実行し、[ネットワーク設定](/docs/ja/network-config) でプロキシセットアップを確認してください。

<h3 id="api-returned-an-empty-or-malformed-response">
  API が空または不正な形式の応答を返しました
</h3>

Claude Code は、失敗したストリーミング要求の非ストリーミング再試行が HTTP 成功ステータスを取得しても、本文が Claude API メッセージではない場合、このエラーを表示します。一般的には HTML エラーまたはサインインページ、空の本文、または別の形式の JSON です。プロキシ、ゲートウェイ、またはネットワークサインインページが API の代わりに応答することが通常の原因です。Claude Code は要求を再試行せず、ターンはこのエラーで終了します。

```text theme={null}
API returned an empty or malformed response (HTTP 200) — check for a proxy or gateway intercepting the request.
```

その冒頭の後、メッセージは戻ってきたものと失敗した要求を報告します。

* `Response:` 句は、コンテンツタイプ、本文の種類（`body is an HTML page` または `empty body` など）、バイト単位のサイズ、および応答が Anthropic リクエスト ID を運んだかどうかを示します。応答が `nginx` または `cloudflare` などの認識可能なサーバーを名前で指定するか、`cf-ray` または `via` などの中間ヘッダーを運ぶ場合、句はそれらもリストします。
* 失敗したストリーミング要求の ID と失敗をトリガーした障害を名前で指定する文。ストリームが障害の前に開いていた場合、到着したストリームイベント数と、いずれかが到着した場合、試行が失敗したときにストリームが沈黙していた時間も報告します。

v2.1.234 より前では、メッセージは `intercepting the request` の後で終了しました。

**対応方法：**

* `Response:` 句を読んで、どのシステムが応答したかを確認してください。HTML 本文、Anthropic リクエスト ID がない、または `nginx` または `cloudflare` などの名前付きサーバーは、Claude Code と API の間に何かが代わりに応答したことを意味します。
* [LLM ゲートウェイ](/docs/ja/llm-gateway-connect#troubleshoot-gateway-errors) を通じてルーティングする場合は、直接要求でルートをテストし、非 API 応答を返すホップを修正してください。
* ゲスト Wi-Fi などのサインインページを持つネットワーク上では、ブラウザーでサインインを完了してから再試行してください。
* ゲートウェイを通じた非ストリーミングルートのみが壊れている場合は、[`CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK=1`](/docs/ja/env-vars#variables) を設定して、ストリーミング中に失敗した要求がこのフォールバックではなく通常の再試行パスに進むようにしてください。ただし、ストリーミングエンドポイント自体が `404` を返す場合は除きます。その場合、Claude Code は引き続きフォールバックします。

<h3 id="streaming-response-ended-before-any-complete-data-was-received">
  ストリーミング応答が完全なデータを受け取る前に終了しました
</h3>

モデルプロバイダーからのストリーミング応答が完了しましたが、使用可能なデータを配信しなかったため、Claude Code は要求をストリーミングなしで再送信してターンを完了しました。Claude Code は警告を 1 回のセッションごとに、対話型セッションのみで表示します。v2.1.239 より前では、Claude Code はストリーミングなしで黙って再試行しました。

```text theme={null}
Streaming response ended before any complete data was received. Retrying without streaming. If this keeps happening, check any proxy or gateway between Claude Code and your model provider.
```

Claude Code は影響を受けた各要求を 2 回送信します。空のストリーミング試行と再試行です。通常の原因は、戻りの途中でストリーミング応答本文を消費または変換するプロキシまたはゲートウェイです。

**対応方法：**

* Claude Code とモデルプロバイダーの間のプロキシまたはゲートウェイを設定して、ストリーミング応答本文とそのヘッダーを変更されずに通すようにしてください。
* [Amazon Bedrock](/docs/ja/amazon-bedrock) では、[ゲートウェイまたはプロキシの背後でのストリーミングエラー](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy) を参照して、ヘッダーと本文の要件を確認してください。

<h3 id="bedrock-streaming-response-has-an-unexpected-content-type">
  Bedrock ストリーミング応答に予期しないコンテンツタイプがあります
</h3>

Claude Code と [Amazon Bedrock](/docs/ja/amazon-bedrock) の間のゲートウェイまたはプロキシがストリーミング応答本文またはその `Content-Type` ヘッダーを変換しています。Amazon Bedrock はストリーミング応答を `application/vnd.amazon.eventstream` として配信します。読み取れない本文をデコードするのではなく、Claude Code は異なるコンテンツタイプを報告する成功したストリーミング応答を拒否します。Claude Code は要求を再試行しません。

```text theme={null}
Bedrock streaming response has content-type "text/event-stream"; expected "application/vnd.amazon.eventstream". A gateway or proxy between Claude Code and Bedrock is likely transforming the response body — Bedrock's binary event-stream format must be passed through unmodified. Set CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1 to suppress this check while the gateway is being fixed.
```

v2.1.208 より前では、同じ設定ミスは、応答全体がバッファリングされた後、`API Error: Truncated event message received` として表示されました。

**対応方法：**

* ゲートウェイを設定して、`InvokeModelWithResponseStream` 応答本文とその `Content-Type` ヘッダーを変更されずに通すようにしてください。ストリームをサーバー送信イベントとして再発行する中間者は一般的な原因です。
* [`CLAUDE_CODE_DISABLE_BEDROCK_CONTENT_TYPE_GUARD=1`](/docs/ja/env-vars) を設定するとこのエラーが非表示になりますが、Claude Code は書き直されたヘッダーの下でバイナリ本文をデコードしないため、これらの要求はより遅い非ストリーミングパスにフォールバックします。[ゲートウェイまたはプロキシの背後でのストリーミングエラー](/docs/ja/amazon-bedrock#streaming-errors-behind-a-gateway-or-proxy) を参照してください。

<h3 id="ssl-certificate-errors">
  SSL 証明書エラー
</h3>

ネットワーク上のプロキシまたはセキュリティアプライアンスが TLS トラフィックを独自の証明書でインターセプトしており、Claude Code はそれを信頼しません。

```text theme={null}
Unable to connect to API: SSL certificate verification failed. Check your proxy or corporate SSL certificates
Unable to connect to API: Self-signed certificate detected. Check your proxy or corporate SSL certificates
```

v2.1.199 以降、証明書検証の失敗は再試行されないため、このエラーは完全な [再試行予算](#automatic-retries) の後ではなく、最初の試行時に表示されます。以前のバージョンは、表示する前に数分間再試行しました。ハンドシェイクタイムアウトなどの一時的な TLS 条件は、引き続き再試行されます。

`/login` とスタートアップ接続チェック中に、同じ障害は OpenSSL コードと修正をインラインで報告されます。

```text theme={null}
SSL certificate error (UNABLE_TO_GET_ISSUER_CERT_LOCALLY). If you are behind a corporate proxy or TLS-intercepting firewall, set NODE_EXTRA_CA_CERTS to your CA bundle path, or ask IT to allowlist *.anthropic.com. Run `claude doctor` for details.
```

**対応方法：**

* 組織の CA バンドルをエクスポートし、`NODE_EXTRA_CA_CERTS=/path/to/ca-bundle.pem` で Claude Code を指してください。
* 完全なセットアップ手順については、[ネットワーク設定](/docs/ja/network-config#custom-ca-certificates) を参照してください。
* `NODE_TLS_REJECT_UNAUTHORIZED=0` を設定しないでください。これは証明書検証を完全に無効にします。

<h3 id="host-not-allowed-in-a-cloud-session">
  クラウドセッションでホストが許可されていません
</h3>

クラウドセッションまたはルーチンからのアウトバウンド HTTP リクエストが環境のネットワークポリシーによってブロックされました。

```text theme={null}
HTTP 403
x-deny-reason: host_not_allowed
```

宛先の実際の証明書と一致しない TLS 証明書も表示される場合があります。クラウドセッションはアウトバウンドトラフィックをプロキシを通じてルーティングしてネットワークポリシーを適用するため、一致しない証明書はプロキシが接続を終了したことを意味し、宛先ではありません。

これはクライアント側のネットワーク問題ではありません。クラウドセッションと [ルーチン](/docs/ja/routines) は、セッションのネットワークを通じたアウトバウンドトラフィックが [クラウド環境の](/docs/ja/cloud-environments) 許可リストにフィルタリングされるサンドボックス化された VM 内で実行されます。[GitHub 操作](/docs/ja/cloud-environments#github-proxy) と MCP コネクタトラフィックは別のチャネルを使用するため、他のホストがブロックされている間も機能し続けることができます。**Default** 環境は **Trusted** アクセスを使用し、パッケージレジストリ、クラウドプロバイダー API、コンテナレジストリ、および一般的な開発ドメインの [デフォルト許可リスト](/docs/ja/cloud-environments#default-allowed-domains) を許可し、そのパス上の他のドメインをブロックします。

**対応方法：**

* ルーチンを編集用に開くか、クラウドセッションを開始してください。**Default** などの環境の名前を示すクラウドアイコンを選択して、セレクターを開きます。環境の上にマウスを置き、設定アイコンをクリックしてください。
* **Update cloud environment** ダイアログで、**Network access** を **Trusted** から **Custom** に変更し、ブロックされたドメインを **Allowed domains** に追加してください。1 行に 1 つのドメインを入力してください。**Also include default list of common package managers** をチェックして、カスタムドメインと共に [デフォルト許可リスト](/docs/ja/cloud-environments#default-allowed-domains) を保持してください。無制限のアクセスが必要な場合は、代わりに **Full** を選択してください。
* **Save changes** をクリックしてください。次の実行は更新された許可リストを使用します。

アクセスレベルとデフォルト許可リストについては、[ネットワークアクセス](/docs/ja/cloud-environments#network-access) を参照してください。ローカル CLI セッションはこのポリシーの影響を受けません。

<h3 id="the-proxy-refused-the-connection">
  プロキシが接続を拒否しました
</h3>

Claude が `HTTPS_PROXY` または関連する [プロキシ変数](/docs/ja/network-config#environment-variables) に設定したプロキシを通じて [アーティファクト](/docs/ja/artifacts) を読み取るときに、このメッセージが表示されます。アーティファクトコンテンツは `*.frame.claudeusercontent.com` から来るため、Claude Code は最初にプロキシに `CONNECT` リクエストを送信して、そのホストへのトンネルを開くよう要求します。プロキシが拒否すると、何もホストに到達せず、メッセージはプロキシの HTTP ステータスを運びます。

```text theme={null}
artifact content fetch failed (proxy refused the connection: HTTP 407)
artifact content fetch failed (proxy refused the connection: HTTP 403)
the proxy refused the connection to the artifact's content host (HTTP 502)
```

ステータスは `CONNECT` に対するプロキシの応答です。ホストは応答しなかったため、各ステータスは異なる修正を指しています。

* `HTTP 407`：プロキシは受け取らなかった認証情報を必要とします。[基本認証](/docs/ja/network-config#basic-authentication) が示すように、プロキシ URL に認証情報を入力してください。
* `HTTP 403`：プロキシは `*.frame.claudeusercontent.com` へのトンネリングを拒否します。プロキシを実行している人に、[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements) にリストされているそのホストを許可するよう依頼してください。
* `HTTP 502` などの他のステータス：プロキシはホストに到達できないなど、独自の理由でトンネルを開きませんでした。プロキシのログでステータスを検索してください。
* ステータスの代わりに `unreadable reply`：プロキシアドレスにあるものが HTTP ステータス行で応答しませんでした。アドレスが HTTP プロキシであることを確認してください。

**対応方法：**

* [プロキシ設定](/docs/ja/network-config#proxy-configuration) で説明されているように、プロキシ変数のアドレスと認証情報を確認してから、Claude Code を開始するシェルから `curl -x http://proxy.example.com:8080 -I https://api.anthropic.com` を実行してください。独自のプロキシ URL を使用してください。Windows PowerShell では、`curl.exe` を実行してください。このプローブが同じ方法で失敗する場合は、最初にプロキシセットアップを修正してください。成功する場合、拒否はアーティファクトホストに固有です。
* ネットワークが Claude Code をアーティファクトホストに直接到達させる場合は、`.frame.claudeusercontent.com` を [`NO_PROXY`](/docs/ja/network-config#environment-variables) に追加してください。エントリを狭く保ってください。より広い `.claudeusercontent.com` エントリは、[IP 許可リスト](/docs/ja/network-config#organization-ip-allowlists-and-proxy-egress) を持つ組織がプロキシ上に保つ必要がある `bridge.claudeusercontent.com` のプロキシもバイパスします。

v2.1.238 より前では、Claude Code は拒否されたトンネルを一般的なネットワークエラーとして報告しました。

<h3 id="the-cloud-environments-service-returned-an-empty-or-unexpected-response">
  クラウド環境サービスが空または予期しない応答を返しました
</h3>

Claude Code は、CLI からクラウドセッションを作成するときや [`/remote-env`](/docs/ja/cloud-environments#select-an-environment-from-the-cli) を実行するときなど、複数のポイントで [クラウド環境](/docs/ja/cloud-environments) リストをリクエストします。サーバーの応答を読み取れない場合、次のいずれかのメッセージが表示されます。

```text theme={null}
The cloud environments service returned an empty response (HTTP 200 with no body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 with a non-JSON body). This is usually temporary — try again in a moment.
The cloud environments service returned a response in an unexpected format (HTTP 200 without a usable environments list). This is usually temporary — try again in a moment.
```

サーバーはリクエストを受け入れましたが、環境リストではない本文で応答しました。空、JSON ではない、または環境リストのない JSON です。これは通常、サービス側の中断を伴い、独自にクリアされます。リストをリクエストした表面に応じて、Claude Code は `/remote-env` ダイアログの `couldn't list environments:` などのプレフィックスを追加する場合があります。

**対応方法：**

* アクションを再試行してください。Claude Code はアクションのたびにリストをリクエストします。
* メッセージが表示され続ける場合は、[status.claude.com](https://status.claude.com) でアクティブなインシデントを確認してください。

v2.1.236 より前では、Claude Code はこれらのメッセージの代わりに生の JavaScript TypeError を表示しました。

<h3 id="couldnt-reconnect-to-your-remote-control-session">
  Remote Control セッションに再接続できませんでした
</h3>

```text theme={null}
Couldn't reconnect to your Remote Control session. Retry, or start a fresh session without --resume.
```

`claude --resume` または `claude --continue` で再開すると、その会話に記録された [Remote Control](/docs/ja/remote-control) セッションに再接続します。このメッセージは、ネットワーク中断またはサーバーエラーなど、一時的な理由で再接続が失敗したことを意味するため、Claude Code はリモートセッションがまだ存在するかどうかを確認できません。ローカルセッションは Remote Control なしで実行し続けます。

**対応方法：**

* `/remote-control` を実行して接続を再試行してください。
* `claude --remote-control` で新しいセッションを開始して、新しい Remote Control セッションを作成してください。
* 他の Remote Control スタートアップメッセージについては、[Remote Control のトラブルシューティング](/docs/ja/remote-control#troubleshooting) を参照してください。

サーバーが代わりに前のセッションが消えたことを報告する場合、このメッセージは表示されません。Claude Code は、その代わりに新しいセッションを開始するか、[`Previous session is unavailable — run /remote-control to start a new one`](/docs/ja/remote-control#previous-session-is-unavailable) を表示します。これは [会話の再接続レコード](/docs/ja/remote-control#resume-outcomes) に依存します。v2.1.227 から v2.1.231 では、Claude Code は代わりに `Remote Control could not resume the previous session under the current login` で始まるメッセージを表示し、[以前のバージョンは異なる動作をしました](/docs/ja/remote-control#reconnect-history)。

<h3 id="sessions-ended-while-this-machine-was-offline">
  このマシンがオフラインの間にセッションが終了しました
</h3>

Claude Code は、マシンがオフラインになった時間が長すぎて、サーバーがマシンが提供していた Remote Control 環境をクリーンアップした後、[`claude remote-control`](/docs/ja/remote-control#start-a-remote-control-session) を実行しているターミナルにこのメッセージを表示します。その環境のセッションが終了し、それらを再開することはできません。カウントは終了したセッション数です。

```text theme={null}
2 sessions ended while this machine was offline — the environment was cleaned up on the server and can't be resumed.
```

**対応方法：**

* Claude Code がこのメッセージの下で保持されたワークツリーをリストする場合、それらから未コミットの作業を取得してください。
* `claude remote-control` を実行して新しい環境を開始してください。

<h3 id="couldnt-share-the-transcript">
  トランスクリプトを共有できませんでした
</h3>

[セッション品質調査](/docs/ja/data-usage#session-quality-surveys) などの調査プロンプトからセッショントランスクリプトを共有することに同意した後、Claude Code はそれを Anthropic にアップロードするか、サードパーティプロバイダー上、[Claude apps ゲートウェイ](/docs/ja/claude-apps-gateway) セッション上、および Anthropic 認証情報が利用できない場合にローカルアーカイブを保存します。このメッセージは共有が完了しなかったことを意味します。

```text theme={null}
Couldn't share the transcript.
```

アップロードは 8 MiB の制限に適合する必要があります。長いセッションでは、Claude Code は段階的に共有の一部をドロップし、最後のリクエストのモデル設定を最初に、次に構造化された会話とサブエージェントトランスクリプトをドロップし、削減されたバージョンを送信できない場合、またはネットワークまたはサーバーエラーがアップロードを停止する場合にのみ、このメッセージを表示します。Claude Code がローカルアーカイブを保存する場合、メッセージはアーカイブを書き込めなかったことを意味します。

**対応方法：**

* `/feedback` を実行して、何が起こったかの説明と共にトランスクリプトを送信してください。環境で `/feedback` が利用できない場合は、[エラーを報告する](#report-an-error) を参照してください。
* 他のリクエストも失敗している場合は、ネットワーク接続を確認し、[API に接続できません](#unable-to-connect-to-api) を参照してください。

<h2 id="request-errors">
  リクエストエラー
</h2>

これらのエラーはリクエストの内容に関連しています。ほとんどはリクエストを拒否した後に API から返されます。いくつかはリクエストが送信される前に Claude Code によってローカルで生成されます。

<h3 id="prompt-is-too-long">
  プロンプトが長すぎます
</h3>

会話と添付ファイルがモデルのコンテキストウィンドウを超えています。

```text theme={null}
Prompt is too long
```

インタラクティブセッションでは、Claude Code はこのエラーを次のように表示します。

```text theme={null}
Context limit reached · /compact or /clear to continue
```

[`DISABLE_COMPACT`](/docs/ja/env-vars) が設定されている場合、この行は `/clear` のみを表示します。圧縮失敗形式など、エラーのより長い形式は `Prompt is too long ·` という表現を保持します。`-p` 出力とトランスクリプトでは、テキストは `Prompt is too long` のままです。

[ユーザー設定](/docs/ja/settings-reference#autocompactenabled)で自動圧縮をオフにした場合、この行は次のように表示されます。

```text theme={null}
Context limit reached · /compact or /clear to continue · auto-compact is off · /config to turn it on
```

`/config` の **Auto-compact** トグルは、ユーザー設定に `autoCompactEnabled` を書き込みます。ヒントは `/config` の変更が有効になる場合にのみ表示されます。たとえば、[`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) または [`DISABLE_COMPACT`](/docs/ja/env-vars) が自動圧縮をオフにした場合は表示されません。また、プロジェクトまたはマネージド設定などのより高い優先度のスコープが `autoCompactEnabled` を `false` に設定した場合も表示されません。v2.1.235 より前では、この行に自動圧縮ヒントは含まれていませんでした。

Amazon Bedrock はこの状態を `Input is too long for requested model.` として報告し、Claude Code は同じ方法で処理します。v2.1.217 より前では、Claude Code は Bedrock の表現を認識しなかったため、自動圧縮はトリガーされず、`/compact` は同じエラーで失敗しました。

[Claude apps gateway](/docs/ja/claude-apps-gateway-config#upstream-error-messages) は、クラウドアップストリームがプロバイダー独自のエラー形式でリクエストを拒否した場合、この状態を `capability_rejected: prompt_too_long` として報告します。Claude Code はトークンを `Prompt is too long` と同じように扱います。v2.1.228 より前では、Claude Code はトークンを認識しなかったため、自動圧縮はトリガーされませんでした。

このターンで自動圧縮が実行され、利用不可のモデルや認証失敗などの基礎となるエラーで失敗した場合、メッセージはセパレータの後にそのエラーを名前付けします。

```text theme={null}
Prompt is too long · automatic compaction failed: <the underlying error>
```

名前付けされたエラーを最初に解決してください。`/compact` は解決するまで同じエラーで失敗します。v2.1.229 より前では、失敗した自動圧縮は原因なしで `Prompt is too long` を表示していました。

単一交換の会話には要約する以前のターンがありません。自動圧縮が実行されるはずの場合、Claude Code は試行をスキップし、代わりにリクエストを何が満たしているかを説明します。API がエラーでトークン数を報告しない場合、メッセージは次のように読みます。

```text theme={null}
Prompt is too long · this conversation is a single exchange and cannot be compacted — the request size comes mostly from system prompt, tool definitions, or attachments.
```

API がエラーでトークン数を報告する場合、Claude Code はそれを会話のサイズの独自の推定値と比較して、リクエストの大部分が何であるかを判断します。会話独自のコンテンツ、またはシステムプロンプト、ツール定義、および Claude Code が送信する添付ファイルコンテンツです。会話独自のコンテンツがリクエストの大部分である場合、メッセージは次のように読みます。

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) and this conversation's own content is most of it. A single-exchange conversation cannot be compacted; start with less content (smaller files or pasted text).
```

リクエストの大部分が会話外にある場合、メッセージは次のように読みます。

```text theme={null}
Prompt is too long · the request is ~<request tokens> tokens (limit <limit>) but this conversation is only ~<conversation tokens> tokens — the rest is system prompt, tool definitions, and attachment content. A single-exchange conversation cannot be compacted; reduce attached files/tools or start with less context.
```

v2.1.162 より前では、Claude Code は圧縮を試行し、失敗時に裸の `Prompt is too long` を表示していました。

**対応方法：**

* マルチターン会話では、`/compact` を実行して以前のターンを要約し、スペースを解放するか、`/clear` を実行して新しく開始します。単一交換の会話は圧縮できないため、代わりにリクエストを縮小してください
* `/context` を実行して、ウィンドウを消費しているものの内訳を確認します。システムプロンプト、ツール、メモリファイル、およびメッセージです
* `/mcp disable <name>` で使用していない MCP サーバーを無効にして、コンテキストからツール定義を削除します
* 大きな `CLAUDE.md` メモリファイルをトリミングするか、指示を [パススコープ規則](/docs/ja/memory#path-specific-rules)に移動して、関連する場合にのみ読み込みます
* サブエージェントは親セッションからすべての MCP ツール定義を継承します。これは最初のターンの前にコンテキストウィンドウを満たす可能性があります。サブエージェントを生成する前に、使用していない MCP サーバーを無効にします
* 自動圧縮はデフォルトでオンになっており、通常このエラーを防ぎます。`/config` または [`DISABLE_AUTO_COMPACT`](/docs/ja/env-vars) でオフにした場合は、オンに戻してください。オフのままにする場合は、ウィンドウが満杯になる前に `/compact` を自分で実行してください。

[コンテキストウィンドウを探索](/docs/ja/context-window)を参照して、コンテキストがどのように満杯になるかのインタラクティブビューを確認してください。

<h3 id="context-exceeds-the-token-limit">
  コンテキストがトークン制限を超えています
</h3>

`/context` は、会話がモデルのコンテキストウィンドウを超えて成長した場合、その出力の上部にこの警告を表示します。[`Prompt is too long`](#prompt-is-too-long) でリクエストが失敗するまで、スペースを解放してください。インタラクティブセッションは、そのエラーを `Context limit reached` 行として表示します。

```text theme={null}
Context exceeds the 200k-token limit by 94k tokens — run /compact or /clear to continue.
```

超過した制限がモデルのコンテキストウィンドウより小さい圧縮ウィンドウ（1M コンテキストモデルの 200K 境界など）である場合、警告は異なります。リクエストは圧縮ウィンドウを超えて成功します。名前付けされたコマンドを実行して、使用量をそれ以下に戻します。

```text theme={null}
Context is 94k tokens past the 200k-token compaction window — run /compact to reduce usage.
```

両方の形式は、[`DISABLE_COMPACT`](/docs/ja/env-vars) を設定した場合、`/compact` の代わりに `/clear` を名前付けします。

**対応方法：**

* マルチターン会話では、`/compact` を実行して以前のターンを要約し、スペースを解放します。代わりに新しく開始するには、`/clear` を実行してください
* 使用量を削減するその他の方法については、[プロンプトが長すぎます](#prompt-is-too-long)を参照してください

v2.1.216 より前では、`/context` は 100% を超える使用量を表示し、それが何を意味するか、または回復方法を説明する警告行がありませんでした。

<h3 id="error-during-compaction-conversation-too-long">
  圧縮中のエラー：会話が長すぎます
</h3>

`/compact` 自体が失敗しました。これは、生成される要約を保持するのに十分な空きコンテキストがないためです。

```text theme={null}
Error during compaction: Conversation too long. Press esc twice to go up a few messages and try again.
```

これは、自動圧縮がトリガーされた時点でウィンドウが既に満杯である場合、または [`Prompt is too long`](#prompt-is-too-long) を見た後に `/compact` を実行した場合に発生する可能性があります。インタラクティブセッションでは、そのエラーは `Context limit reached` 行です。

**対応方法：**

* Esc キーを 2 回押してメッセージリストを開き、数ターン戻ります。これにより、最新のメッセージがコンテキストから削除されます。その後、`/compact` を再度実行してください。
* 戻ることで十分なスペースが解放されない場合は、`/clear` を実行して新しいセッションを開始してください。以前の会話は保存され、`/resume` で再度開くことができます。

このメッセージと他の `/compact` 失敗はエラースタイルで表示されます。v2.1.216 より前では、成功したコマンド出力と同じ薄いスタイルでレンダリングされたため、失敗した圧縮を成功として読むことができました。

<h3 id="request-too-large">
  リクエストが大きすぎます
</h3>

トークン化前の生のリクエストボディが API の 32MB 制限を超えました。通常、大きなペーストコンテンツ、ツール結果、または添付ファイルが原因です。この制限は [コンテキストウィンドウ](#prompt-is-too-long)とは別です。

```text theme={null}
Request too large (max 32MB). Accumulated images and attachments in the conversation pushed the request over the limit. Run /compact, or double press esc to go back and remove attachments.
```

リクエストが Claude API に直接送信され、API 自体がそれを拒否した場合、Claude Code は会話を測定し、回復が機能するかどうかによってメッセージを表現します。プロキシ、ゲートウェイ、またはクラウドプロバイダーを通じて、一般的なメッセージが表示されます。測定された形式：

* `Request too large (max 32MB; 20.1MB of about 33.4MB is images or documents).`：画像またはドキュメントがリクエストを制限を超えました。Claude Code はそれらを削除して再試行します。
* `Request too large for the API's 32MB request limit`：メッセージだけが制限を超えているため、メッセージは `compacting cannot make it fit` と言い、Claude Code は再試行しません。[非インタラクティブモード](/docs/ja/headless)では、メッセージは入力を削減するか、代わりに新しいセッションを開始するよう指示します。

v2.1.212 より前では、十分に蓄積された画像を持つ会話は、すべてのターンで `Request too large (max 32MB). Double press esc to go back and try with a smaller file.` で失敗しました。v2.1.229 より前では、Claude Code は圧縮が役に立たない場合でも、すべての拒否に対して添付ファイルのアドバイスを表示していました。

**対応方法：**

* メッセージが `compacting cannot make it fit` と言う場合、Esc キーを 2 回押して大きなコンテンツを追加したターンを超えて戻るか、`/clear` を実行して新しく開始してください
* それ以外の場合は、`/compact` を実行します。これにより、蓄積された画像と添付ファイルが削除されます
* ファイルの内容をペーストする代わりに、パスで大きなファイルを参照して、Claude がそれらをチャンクで読むことができるようにします
* 画像については、以下の [画像が大きすぎました](#image-was-too-large)を参照してください

<h3 id="image-was-too-large">
  画像が大きすぎました
</h3>

ペーストまたは添付された画像が API のサイズまたは寸法制限を超えています。

```text theme={null}
Image was too large. Double press esc to go back and try again with a smaller image.
API Error: 400 ... image dimensions exceed max allowed size
```

Claude Code は処理不可能な画像をテキストプレースホルダーに置き換えて再試行するため、後続のメッセージは成功します。v2.1.142 より前では、ペーストされた画像は会話に残り、後続のすべてのメッセージで同じエラーを繰り返す可能性がありました。これらのバージョンで回復するには、Esc キーを 2 回押して、画像が追加されたターンを超えて戻ってください。

**対応方法：**

* ペーストする前に画像をリサイズしてください。API は単一の画像で最大 8000 ピクセル、または多くの画像がコンテキストにある場合は 2000 ピクセルまでの画像を受け入れます。
* 全画面ではなく、関連する領域のより厳密なスクリーンショットを撮ってください

<h3 id="unable-to-resize-image">
  画像をリサイズできません
</h3>

Claude Code は、API に送信する前に添付された画像をダウンスケールできませんでした。

```text theme={null}
Unable to resize image — image processing is unavailable and dimensions could not be read from the file header. Please convert the image to PNG, JPEG, GIF, or WebP.
Unable to resize image — dimensions exceed the 2000x2000px limit and image processing failed. Please resize the image to reduce its pixel dimensions.
Unable to resize image (… raw, … base64). The image exceeds the … API limit and compression failed. Please resize the image manually or use a smaller image.
Unable to resize image — could not verify image dimensions are within the 2000x2000px API limit.
```

Claude Code は通常、大きな画像を自動的にリサイズします。これらのエラーは、ネイティブ画像プロセッサが読み込みに失敗したか、エラーを返したため、画像を API 制限内に収まるようにリサイズできなかったことを意味します。

**対応方法：**

* メッセージが画像を変換するよう求めている場合は、PNG、JPEG、GIF、または WebP に変換して、再度添付してください。Claude Code はこれらの形式の寸法を画像プロセッサなしで検証できます。
* メッセージが寸法またはサイズ制限を報告している場合は、その制限以下に画像をリサイズまたは再圧縮してから添付してください。

<h3 id="pdf-errors">
  PDF エラー
</h3>

添付した PDF を処理できませんでした。メッセージはここに非インタラクティブ形式で表示されます。インタラクティブセッションでは、代わりに Esc キーを 2 回押して再試行するよう促します。

```text theme={null}
PDF too large (max 100 pages, 20MB). Try reading the file a different way (e.g., extract text with pdftotext).
PDF is password protected. Try using a CLI tool to extract or convert the PDF.
The PDF file was not valid. Try converting it to text first (e.g., pdftotext).
```

**対応方法：**

* サイズの大きい PDF の場合は、ファイル全体を添付する代わりに、Read ツールでページ範囲を読むよう Claude に依頼するか、`pdftotext` などのツールでテキストを抽出し、パスでファイルを参照してください
* 保護されているか無効な PDF の場合は、パスワードを削除するか、ソースアプリケーションからファイルを再度エクスポートしてから、再度試してください

<h3 id="extra-inputs-are-not-permitted">
  追加入力は許可されていません
</h3>

Claude Code と API の間のプロキシまたは LLM ゲートウェイが `anthropic-beta` リクエストヘッダーを削除したため、API はそれに依存するフィールドを拒否しました。

```text theme={null}
API Error: 400 ... Extra inputs are not permitted ... context_management
API Error: 400 ... Unexpected value(s) for the `anthropic-beta` header
```

Claude Code は、`context_management` や `effort` などのベータのみのフィールドを、それらを有効にする `anthropic-beta` ヘッダーと一緒に送信します。ゲートウェイがボディを転送しますがヘッダーを削除すると、API は認識しないフィールドを見ます。

**対応方法：**

* `anthropic-beta` ヘッダーを転送するようにゲートウェイを設定してください。ゲートウェイが転送する必要があるものについては、[機能パススルー](/docs/ja/llm-gateway-protocol#feature-pass-through)を参照してください。
* フォールバックとして、起動前に [`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`](/docs/ja/env-vars) を設定してください。[プリリリース機能を無効にする](/docs/ja/llm-gateway-protocol#disable-pre-release-capabilities)は正確なスコープをカバーしています。

<h3 id="tool-input-schema-is-invalid">
  ツール入力スキーマが無効です
</h3>

リクエスト内のツールが、API の JSON Schema 検証に失敗する `input_schema` を宣言したため、API はリクエスト全体を拒否しました。`tools.` の後の番号は、検索できる名前ではなく、リクエストのツールリスト内の失敗したツールの位置です。

```text theme={null}
API Error: 400 ... tools.N.custom.input_schema: JSON schema is invalid
API Error: 400 ... tools.N.custom.input_schema.properties: Property keys should match pattern '^[a-zA-Z0-9_.-]{1,64}$'
```

最初の形式は、スキーマが有効な JSON Schema ドラフト 2020-12 ではないことを意味します。2 番目は、トップレベルのプロパティ名がメッセージが引用するパターンと一致しないことを意味します。

Claude Code は、[この検証に失敗するであろう入力スキーマを持つ MCP ツールを除外](/docs/ja/mcp#tools-with-invalid-input-schemas)します。サーバーのツールを読み込むときは、リクエストは通常、このツールを含みません。

[フラグ取得がオフ](/docs/ja/env-vars#features-that-need-feature-flag-fetching)の展開、またはフラグが到着したことのないマシンでは、Claude Code はサーバーのログに拒否されるであろうツールを記録しますが、とにかく送信するため、このエラーは依然として発生する可能性があります。

エラーは、`$schema` で JSON Schema ドラフト 2020-12 以外の JSON Schema 方言を宣言するツールのスキーマに対しても発生する可能性があります。Claude Code はこれらのスキーマを JSON Schema メタスキーマに対してチェックしませんが、トップレベルのプロパティ名チェックは依然として適用されます。

v2.1.216 より前では、展開は除外チェックを実行していませんでした。

**対応方法：**

* Claude Code バージョンが v2.1.216 より前の場合は、`claude update` を実行してください。
* 無効なスキーマを宣言する MCP サーバーを削除するか、[無効にしてください](/docs/ja/mcp#disable-a-server-without-removing-it)。エラーは位置によってのみツールを名前付けします。v2.1.216 以降では、各サーバーのログで、入力スキーマが拒否されるであろうツールを名前付けする行を確認してください。ログが名前付けしない場合は、サーバーを 1 つずつ無効にしてください。
* サーバーを保守している場合は、ツールの `input_schema` を修正してください。スキーマは有効な JSON Schema である必要があり、トップレベルのプロパティ名は 1 ～ 64 文字で、ASCII 文字と数字、`_`、`.`、および `-` のみを使用する必要があります。[無効な入力スキーマを持つツール](/docs/ja/mcp#tools-with-invalid-input-schemas)を参照してください。

<h3 id="theres-an-issue-with-the-selected-model">
  選択されたモデルに問題があります
</h3>

設定されたモデル名が認識されなかったか、アカウントがそれへのアクセス権を持っていません。v2.1.160 の時点で、ここにインタラクティブ形式で表示される末尾のヒントは、サーフェスによって異なります。

```text theme={null}
There's an issue with the selected model (claude-...). It may not exist or you may not have access to it. Run /model to pick a different model.
```

**対応方法：**

* **インタラクティブ CLI**：`/model` を実行して、アカウントで利用可能なモデルから選択してください。
* **非インタラクティブモード（`-p`）**：有効なエイリアスまたは ID で `--model` を渡すか、[`ANTHROPIC_MODEL`](/docs/ja/env-vars)を設定してください。エラーテキストはこのサーフェスで `Run --model` を表示します。
* **Agent SDK**：モデルはプログラムで設定されるため、エラーテキストはヒントを省略します。TypeScript で [`Options` の `model`](/docs/ja/agent-sdk/typescript#options)を設定するか、Python で [`ClaudeAgentOptions(model=...)`](/docs/ja/agent-sdk/python#claudeagentoptions)を設定し、構造化された `model_not_found` エラーを処理して、独自の再試行またはモデルピッカーを表示してください。
* `claude-sonnet-5` などの完全なバージョン ID の代わりに、`sonnet` や `opus` などのエイリアスを使用してください。エイリアスは保守されたデフォルトに解決されるため、古くなりません。[モデル設定](/docs/ja/model-config)を参照してください。
* 間違ったモデルが CLI で戻り続ける場合は、古い ID がどこかに設定されています。[優先順位順](/docs/ja/model-config#setting-your-model)でモデルを設定できる場所を確認し、古い値を削除してください。
* 新しく起動されたモデルは、Amazon Bedrock、Google Cloud の Agent Platform、または Microsoft Foundry が提供する前に Anthropic API で利用可能になる可能性があります。これらのプロバイダーの 1 つで新しいモデル ID をピンしており、このエラーが表示される場合は、プロバイダーのモデルカタログで地域での利用可能性を確認し、新しいモデルがそこに表示されるまで以前のバージョンをピンしたままにしてください。
* Claude Code は期限切れの claude.ai ログインを [ログイン期限切れ](#login-expired)として報告し、このエラーとしてではありません。v2.1.206 より前では、更新できなくなった期限切れのログインはすべてのモデルで失敗しました。古いバージョンでこれが表示される場合は、`/login` を実行してください。
* Google Cloud の Agent Platform デプロイメントについては、[Google Cloud の Agent Platform トラブルシューティング](/docs/ja/google-vertex-ai#troubleshooting)を参照してください。

<h3 id="model-is-not-a-recognized-model-id">
  モデルは認識されたモデル ID ではありません
</h3>

モデルスイッチに渡したモデル文字列は、モデルエイリアス、この Claude Code バージョンが知っているモデル ID、または `claude-` で始まる ID ではありません。通常の原因は、ID のタイプミス、`Sonnet 5` などの表示名（ID `claude-sonnet-5` が予想される）、または新しい Claude Code バージョンのみが認識するエイリアスです。Claude Code はスイッチを直ちに拒否します。v2.1.200 より前では、Claude Code は文字列を保存し、次のリクエストで [選択されたモデルに問題があります](#theres-an-issue-with-the-selected-model)で失敗しました。

```text theme={null}
Model "claud-sonnet-5" is not a recognized model id. Did you mean 'claude-sonnet-5'?
```

末尾のヒントは、最も近いマッチングエイリアスまたはモデル ID を名前付けします。十分に近いものがない場合は、代わりに `Run /model to see available models.` と読みます。

Claude Code はこのエラーをローカルで生成します。スイッチが要求された時点で、API リクエストが行われる前です。これは、[Agent SDK](/docs/ja/agent-sdk/typescript) `setModel()` メソッドを通じてモデルが設定されるか、Claude Code CLI を実行する [Desktop app](/docs/ja/desktop)などのアプリによって適用されます。

**対応方法：**

* 引数なしで `/model` を実行してピッカーを開き、アカウントで利用可能なモデルから選択してから、そこに表示されるエイリアスまたは ID を渡してください
* 新しい Claude Code バージョンがサポートするエイリアスを使用した場合は、`claude update` を実行してください。`claude-` で始まる完全な ID はこのローカルチェックを通過します。サーバーはそのモデルに最小バージョンを要求する可能性があります。[Claude Code はこのモデルをサポートしていません](#claude-code-does-not-support-this-model)を参照してください。
* v2.1.200 より前に保存されたモデルはこのチェックで修復されません。古い値が戻り続ける場合は、[モデルの設定](/docs/ja/model-config#setting-your-model)の下にリストされている場所から削除してください。
* チェックは Anthropic API でのみ実行されます。カスタム `ANTHROPIC_BASE_URL` を含む他のプロバイダーまたはゲートウェイでは、プロバイダーがモデル名を定義するため、Claude Code は任意の文字列を受け入れて渡します。Claude Code は依然として、すべてのプロバイダーで、リクエスト時に [認識されないモデル診断行](#unrecognized-model-id-on-a-request)を書き込むことができます。

<h3 id="claude-opus-is-not-available-with-the-claude-pro-plan">
  Claude Opus は Claude Pro プランでは利用できません
</h3>

アクティブなサブスクリプションプランに、選択したモデルが含まれていません。

```text theme={null}
Claude Opus is not available with the Claude Pro plan. If you have updated your subscription plan recently, run /logout and /login for the plan to take effect.
```

**対応方法：**

* `/model` を実行して、プランに含まれるモデルを選択してください
* 最近プランをアップグレードしてもこれが表示される場合は、`/logout` を実行してから `/login` を実行してください。保存されたトークンはサインイン時のプランを反映するため、Web でアップグレードしても、再認証するまで既存のセッションで有効になりません。
* 各プランに含まれるモデルについては、[claude.com/pricing](https://claude.com/pricing)を参照してください

<h3 id="claude-code-does-not-support-this-model">
  Claude Code はこのモデルをサポートしていません
</h3>

選択したモデルには、リクエストを行っている Claude Code バージョンより新しいバージョンが必要です。サーバーはモデルごとにこれをチェックします。

```text theme={null}
API Error: 400 Claude Code 2.1.219 does not support this model; version 2.1.255 or newer is required. Run 'claude update', or update the Claude desktop app, then try again.
```

**対応方法：**

* `claude update` を実行するか、Claude デスクトップアプリを更新してから、モデルで新しいセッションを開始してください
* 現在のセッションで作業を続けるには、`/model` で別のモデルに切り替えてください

<h3 id="model-is-restricted-by-your-organizations-settings">
  モデルは組織の設定によって制限されています
</h3>

組織の管理者が claude.ai 管理コンソールでこのモデルを無効にしたか、マネージド設定の [`availableModels`](/docs/ja/model-config#restrict-model-selection)許可リストで除外されています。制限されたモデルが `--model`、`ANTHROPIC_MODEL`、または `model` 設定で設定された場合、Claude Code は許可されたモデルを代用して続行します。制限されたモデルに対して `/model <name>` を入力すると、`Run /model to choose a different model.` で拒否され、セッションは現在のモデルを保持します。

```text theme={null}
Model "claude-opus-4-8" is restricted by your organization's settings. Using claude-sonnet-4-6 instead.
```

エージェント、スキル、またはコマンド名で始まるお知らせは、制限が [サブエージェントの要求されたモデル](/docs/ja/sub-agents#choose-a-model)に適用されたことを意味します。サブエージェントは代用モデルで実行され、セッションのモデルは変わりません。v2.1.223 より前では、Claude Code はお知らせを Agent ツールで起動されたサブエージェントに対してのみ表示していました。

Claude Code は、`opus`、`sonnet`、`haiku`、または `fable` の 1 つであるモデルファミリーエイリアスを、その最新バージョンではなく、そのファミリーへのリクエストとして扱います。Anthropic API および [Claude Platform on AWS](/docs/ja/claude-platform-on-aws)では、制限されたファミリーエイリアスは、組織と `availableModels` 許可リストが許可する最新バージョンのファミリーに解決され、代用お知らせはそのバージョンを名前付けします。Claude Code は `/model <alias>` を拒否するのは、ファミリーのすべてのバージョンが制限されている場合のみです。v2.1.205 より前では、ファミリーエイリアスは、同じファミリーの古いバージョンが許可されている場合でも、最新バージョンのみに基づいて代用または拒否されました。

**対応方法：**

* `/model` を実行して、組織が許可するモデルから選択してください。制限されたモデルはピッカーから非表示になります。
* 制限されたモデルが `--model`、`ANTHROPIC_MODEL`、設定ファイルの `model` フィールド、または [サブエージェント](/docs/ja/sub-agents#choose-a-model)、スキル、またはコマンドの `model` frontmatter で設定された場合は、その値を削除または更新して、お知らせが再度表示されないようにしてください
* 制限されたモデルへのアクセスが必要な場合は、組織の管理者に有効にするよう依頼してください。[組織モデル制限](/docs/ja/model-config#organization-model-restrictions)を参照してください。

<h3 id="model-switch-was-blocked-by-a-premodelswitch-hook">
  モデルスイッチは PreModelSwitch フックによってブロックされました
</h3>

[PreModelSwitch フック](/docs/ja/hooks#premodelswitch)が、ユーザーまたはクライアントが要求したモデルスイッチを承認しなかったため、セッションは現在のモデルを保持します。スイッチが [Agent SDK](/docs/ja/agent-sdk/overview)ホストまたは [Remote Control](/docs/ja/remote-control)から来た場合、メッセージは、ターゲットモデルを名前付けせずに `Model switch blocked by a PreModelSwitch hook` と読みます。

```text theme={null}
Model switch to Opus 4.6 was blocked by a PreModelSwitch hook: Opus 4.6 is retired for this project. Use a newer model.
```

コロンの後の理由は、スイッチを拒否したものを示しています。

* **フックが書いた理由**：PreModelSwitch フックは、[スイッチを拒否したか確認を求めた](/docs/ja/hooks#premodelswitch-decision-control)ときにその理由を提供しました。それが求めることに対応するか、フックが許可するモデルを選択してください。
* **`PreModelSwitch hook <name> did not respond before its timeout`**：[タイムアウト](/docs/ja/hooks#timeouts)の前に応答しないフックがスイッチをブロックします。ハングしているコマンドを修正するか、そのフックの `timeout` を上げてから、再度スイッチしてください。
* **`confirmation required, and this session cannot ask`**：フックは理由なしで `ask` で応答し、制御リクエストは確認プロンプトを表示する方法がありません。[`-p` 実行](/docs/ja/headless)の `/model` コマンドは、理由の後に `(run /model interactively to confirm)` で同じ状態を報告します。インタラクティブセッションからスイッチを行うか、このモデルのフックの決定を変更してください。
* **`so organization-managed PreModelSwitch hooks could not be checked`**：Claude Code は、組織の [マネージドプラグイン](/docs/ja/settings-reference#enabledplugins)が提供する PreModelSwitch フックを判断できませんでした。たとえば、マネージドプラグインの読み込みに失敗したためです。これらのフックの 1 つがスイッチをブロックする可能性があるため、Claude Code はチェックされていないスイッチを適用するのではなく拒否します。理由の開始は、失敗したものを名前付けします。Claude Code はすべてのスイッチ試行で再チェックするため、それ以降にクリアされた失敗はブロックを停止します。ブロックが続く場合は、`claude --debug` を実行してスイッチし、詳細をキャプチャしてから、プラグインを修正するか、管理者に修正を依頼してください。
* **`a PreModelSwitch hook failed before answering`** または **`PreModelSwitch hooks were cancelled (the control stream closed) before answering`**：フック実行は判定なしで終了し、Claude Code はそれを承認として扱いません。`claude --debug` を実行して失敗したものを確認してから、再度スイッチしてください。

v2.1.260 より前では、マネージドプラグイン拒否は `plugin hooks could not be loaded, so PreModelSwitch hooks could not be checked; see the debug log` と読みました。Claude Code はプラグイン読み込みを 1 回再試行してから、セッション内の後のスイッチを拒否しました。組織がプラグインを管理していない場合でも同様です。これらのバージョンでセッションを再開して、プラグイン読み込みを再度実行してください。

<h3 id="thinking-type-enabled-is-not-supported-for-this-model">
  thinking.type.enabled はこのモデルではサポートされていません
</h3>

Claude Code バージョンが選択されたモデルの最小値より古いです。CLI は、モデルが受け入れなくなった思考設定を送信しました。

```text theme={null}
API Error: 400 ... "thinking.type.enabled" is not supported for this model. Use "thinking.type.adaptive" and "output_config.effort" to control thinking behavior.
```

**対応方法：**

* `claude update` を実行して Claude Code を再開してください。Opus 4.7 には v2.1.111 以降が必要です。Opus 4.8 には v2.1.154 以降が必要です。Sonnet 5 には v2.1.197 以降が必要です。Opus 5 には v2.1.219 以降が必要です
* アップグレードできない場合は、`/model` を実行して Opus 4.6 または Sonnet 4.6 を選択してください
* [Agent SDK](/docs/ja/agent-sdk/overview)でこれに遭遇した場合は、SDK パッケージをアップグレードしてください。Opus 4.8 には TypeScript SDK v0.3.154 以降と Python SDK v0.2.88 以降が必要です。Sonnet 5 には TypeScript SDK v0.3.197 以降が必要です。Opus 5 には TypeScript SDK v0.3.219 以降が必要です

<h3 id="effort-isnt-available-with-thinking-turned-off">
  思考がオフの場合、努力は利用できません
</h3>

[拡張思考](/docs/ja/model-config#extended-thinking)をオフにして、`high` より上の [努力レベル](/docs/ja/model-config#adjust-effort-level)で実行しました。モデルはその組み合わせを受け入れないため、API はリクエストを拒否しました。

```text theme={null}
API Error: Effort 'xhigh' isn't available with thinking turned off on this model · run /effort high to continue, or turn thinking back on (unset MAX_THINKING_TOKENS=0)
```

**対応方法：**

* [努力レベルを低下](/docs/ja/model-config#set-the-effort-level)させて、`high` 以下にしてください。
* 思考をオンに戻してください。たとえば、[`MAX_THINKING_TOKENS`](/docs/ja/env-vars)をアンセットするか、設定から [`"alwaysThinkingEnabled": false`](/docs/ja/settings-reference#alwaysthinkingenabled)を削除してください。

v2.1.242 より前では、Claude Code は API 独自のメッセージを表示していました。`API Error: 400 output_config.effort 'xhigh' is not supported when thinking is disabled on this model. Use effort 'high' or below, or enable thinking.` v2.1.251 より前では、Claude Code は設定した努力レベルでリクエストを送信したため、Opus 5 は思考がオフの場合、`high` より上のすべてのリクエストを拒否しました。Claude Code は現在、Opus 5 などの組み合わせを拒否することが分かっているモデルに努力 `high` を送信するため、v2.1.251 以降では、このエラーは Claude Code が知らないモデルからのみ到達します。

<h3 id="thinking-budget-exceeds-output-limit">
  思考予算が出力制限を超えています
</h3>

設定された拡張思考予算が最大応答長を超えているため、実際の答えのためのスペースが残っていません。

```text theme={null}
API Error: 400 ... max_tokens must be greater than thinking.budget_tokens
```

Claude Code は Anthropic API でこれらの値を自動的に調整します。通常、Amazon Bedrock または Google Cloud の Agent Platform でこのエラーが表示されるのは、[`MAX_THINKING_TOKENS`](/docs/ja/env-vars)がプロバイダーの出力制限より高く設定されている場合、またはプランモードが思考予算を上げる場合です。

**対応方法：**

* `MAX_THINKING_TOKENS` を低下させるか、[`CLAUDE_CODE_MAX_OUTPUT_TOKENS`](/docs/ja/env-vars)を思考予算より上に上げてください
* [拡張思考](/docs/ja/model-config#extended-thinking)を参照して、予算が出力長とどのように相互作用するかを確認してください

<h3 id="tool-use-or-thinking-block-mismatch">
  ツール使用または思考ブロックの不一致
</h3>

会話履歴が不整合な状態で API に到達しました。通常、ツール呼び出しが中断されたか、ターンがストリーム中に編集された後です。

```text theme={null}
API Error: 400 due to tool use concurrency issues. Run /rewind to recover the conversation.
API Error: 400 ... unexpected `tool_use_id` found in `tool_result` blocks
API Error: 400 ... thinking blocks ... cannot be modified
```

3 つのバリアントはすべて同じことを意味します。履歴内の `tool_use`、`tool_result`、および `thinking` ブロックのシーケンスが、API が期待するものと一致しなくなりました。

**対応方法：**

* Opus 4.7 または Opus 4.8 を使用している場合は、最初に `claude update` を実行してください。v2.1.156 より前のバージョンは、通常のツール使用中にこのエラーをトリガーでき、`/rewind` はそれをクリアしません。
* `/rewind` を実行するか、Esc キーを 2 回押して、破損したターンの前のチェックポイントに戻り、そこから続行してください。[チェックポイント](/docs/ja/checkpointing)を参照して、チェックポイントがどのように作成および復元されるかを確認してください。

<h3 id="unsupported-tool-content-removed">
  サポートされていないツールコンテンツが削除されました
</h3>

Claude Code が Anthropic API に直接接続し、保存されたセッションを読み込むまたはプレビューする場合、Anthropic API が受け入れないツールコンテンツを削除し、2 つの思考ブロック間の削除されたコンテンツが座っていた場所にこの行を残します。

```text theme={null}
[Unsupported tool content removed]
```

このようなコンテンツは、通常、[`ANTHROPIC_BASE_URL`](/docs/ja/env-vars)を通じて設定されたサードパーティプロキシなど、API の形式で応答する Anthropic API 以外のものがセッションファイルに到達します。これは別のプロバイダーのツール呼び出しを変換します。Claude Code は、セッションが Anthropic API に直接接続する場合にのみそれを削除し、セッションがプロキシを通じて実行されるか別のプロバイダーで実行される場合、保存された履歴をそのまま読み込みます。v2.1.246 より前では、Claude Code はツール使用とその結果を API に送信し、再開されたセッションのすべてのターンは `messages.1.content.0.server_tool_use.name: Input should be 'web_search', 'web_fetch', ...` などの 400 エラーで失敗しました。

**対応方法：**

* プレースホルダー行が表示される場合は、対応は不要です。セッションは削除されたコンテンツなしで続行します。
* 再開されたセッションのすべてのターンが 400 エラーで失敗する場合は、`claude update` を実行してセッションを再度再開してください。v2.1.246 より前のバージョンはコンテンツを削除しません。

<h3 id="usage-policy-refusal">
  使用ポリシー拒否
</h3>

API は、会話内のコンテンツが [使用ポリシー](https://www.anthropic.com/legal/aup)チェックをトリガーしたため、応答を拒否しました。メッセージには、拒否が正しくないと思われる場合にサポートに引用できるリクエスト ID が含まれています。

```text theme={null}
API Error: Opus 4.6 can't help with this. Start a new session to continue.

Send feedback with /feedback or learn more: https://www.anthropic.com/legal/aup
```

メッセージは、拒否したモデルを名前付けするか、モデルが記録されていない場合は `Claude` を名前付けします。

チェックは最新のプロンプトだけでなく、完全な会話を評価するため、同じセッションで新しいメッセージを送信すると、通常、同じ拒否が再度トリガーされます。同じことが `--continue` または `--resume` でセッションを終了して再度開いた後にも適用されます。ディスク上のトランスクリプトには依然としてトリガーコンテンツが含まれているためです。[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、および [Microsoft Foundry](/docs/ja/microsoft-foundry)では、このメッセージはモデルのセーフティ対策がサイバーセキュリティトピックとしてフラグを立てたリクエストもカバーしています。[セーフティ対策がサイバーセキュリティトピックをフラグ立てしました](#safety-measures-flagged-a-cybersecurity-topic)を参照してください。

v2.1.219 より前では、メッセージは `Claude Code is unable to respond to this request, which appears to violate our Usage Policy (https://www.anthropic.com/legal/aup). Please double press esc to edit your last message or start a new session for Claude Code to assist with a different task.` と読みました。

**対応方法：**

* Esc キーを 2 回押すか `/rewind` を実行して、拒否をトリガーしたターンの前のチェックポイントに戻り、別のアプローチを試してください。[チェックポイント](/docs/ja/checkpointing)を参照してください。
* どのターンが原因かを特定できない場合は、`/clear` を実行して同じプロジェクトで新しい会話を開始してください。以前の会話はディスクに保存され、`/resume` で利用可能なままです。
* [非インタラクティブモード](/docs/ja/headless)（`-p`）では、巻き戻しが利用できないため、`--continue` なしで新しいセッションで言い換えられたプロンプトで再試行してください。ポリシーチェックはモデルによって異なるため、`--model` で別のモデルに切り替えると、場合によっては拒否が解決される可能性があります。

<h3 id="safety-measures-flagged-a-cybersecurity-topic">
  セーフティ対策がサイバーセキュリティトピックをフラグ立てしました
</h3>

モデルのセーフティ対策が、会話内のコンテンツをサイバーセキュリティトピックとしてフラグ立てしました。メッセージは、リクエストをフラグ立てしたモデルを名前付けします。

```text theme={null}
API Error: Opus 4.8's safeguards flagged this message. Our intentionally broad safeguards allow us to deliver more capabilities faster, but can sometimes flag legitimate cybersecurity work. Apply to the Cyber Verification Program to reduce these interruptions. Send feedback with /feedback or learn more: https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude
```

メッセージは [Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude)にリンクしており、正当なサイバーセキュリティ作業へのアクセスを許可します。

[Amazon Bedrock](/docs/ja/amazon-bedrock)、[Google Cloud の Agent Platform](/docs/ja/google-vertex-ai)、および [Microsoft Foundry](/docs/ja/microsoft-foundry)では、サイバーセキュリティフラグは代わりに [使用ポリシー拒否](#usage-policy-refusal)メッセージを生成します。

セーフガード自体はサーバー側であり、v2.1.203 より前のものです。それ以降のクライアントリリースはメッセージの表現のみを変更しました。
v2.1.203 ～ v2.1.218 では、メッセージは `<model> has safety measures that flagged this message for a cybersecurity topic. To learn about the Cyber Verification Program and apply for access, visit our help center:` と読み、その後に同じヘルプセンターリンクが続き、インタラクティブセッションは `If you were not engaging in a cybersecurity topic, please send feedback via /feedback.` を追加しました。
v2.1.203 より前では、`<model>'s safeguards flagged this message for a cybersecurity topic. If your work requires this access, you can apply for an exemption:` と読み、その後に免除フォームリンクが続きました。

**対応方法：**

* 作業にこのコンテンツが必要な場合は、[Cyber Verification Program](https://support.claude.com/en/articles/14604842-real-time-cyber-safeguards-on-claude)を通じてアクセスを申請してください
* リクエストがサイバーセキュリティトピックについてではなかった場合は、`/feedback` を実行して誤検知を報告してください
* 同じセッションで作業を続けるには、Esc キーを 2 回押すか `/rewind` を実行して、フラグをトリガーしたターンの前のチェックポイントに戻り、別のアプローチを試してください。[チェックポイント](/docs/ja/checkpointing)を参照してください。

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

`claude install`、`claude update`、または[自動アップデーター](/docs/ja/setup#auto-updates)が Claude Code バイナリをフェッチしている間にダウンロードサーバーへの接続が閉じられ、リトライが回復しませんでした。Claude Code は、接続がドロップされた場合、転送が停止した場合、またはダウンロードされたファイルがチェックサムに失敗した場合、最大 3 回の試行でダウンロードを再試行します。404 などの完了した HTTP エラーは、サーバーが既に応答しているため再試行されません。v2.1.202 より前では、単一の接続ドロップはダウンロードを即座に失敗させ、リトライの代わりに単なるエラー `aborted` を表示していました。

```text theme={null}
The connection dropped while downloading the update (attempt 3/3: aborted). Check your network — proxies sometimes cut off large downloads.
```

括弧内のテキストは、失敗した試行と基になるネットワークエラーを示します。`claude update` は stderr でメッセージの前に `Error: Failed to install native update` を付けます。

接続は保持されているがダウンロードが 10 分以内に完了しない場合、代わりに `Download timed out: exceeded the total deadline` で失敗します。Claude Code はタイムアウトしたダウンロードを再試行しません。期限内に完了するのに十分な速度がない接続は、即座に再試行しても完了しないためです。以下の手順は両方のメッセージに適用されます。

通常の原因は、長い転送を完了する前に閉じるプロキシまたはゲートウェイです。Claude Code バイナリは大きなダウンロードであるため、通常の API トラフィックに影響を与えないプロキシ接続制限でも、それを中断する可能性があります。

**対処方法：**

* `claude update` を再度実行します。それ以外の場合は健全なネットワークで、ダウンロードは通常、次の実行で成功します。タイムアウトメッセージの場合は、より高速またはスロットルされていないネットワークから再度実行します。
* ネットワークがプロキシを必要とする場合は、インストーラーまたは `claude update` を実行する前に `HTTPS_PROXY` を設定します。[ネットワーク接続の確認](/docs/ja/troubleshoot-install#check-network-connectivity)を参照してください。
* 企業プロキシが転送を閉じ続ける場合は、ネットワークチームに `downloads.claude.ai` からの完全なダウンロードを許可するよう依頼します。[ネットワークアクセス要件](/docs/ja/network-config#network-access-requirements)を参照してください。
* シェルから `claude doctor` を実行して、インストール診断を実行します

<h2 id="command-line-errors">
  コマンドラインエラー
</h2>

これらのエラーは、`claude` コマンドラインとそのサブコマンド、プロンプトで送信したコマンド名、および `/security-review` などのコマンドから発生します。これらのコマンドはシェルコマンドを実行してコンテキストを収集してからプロンプトを実行します。`/tui` からのエラーも同様です。これは CLI を再起動します。

<h3 id="conflict-between-bg-and-print">
  \--bg と --print の競合
</h3>

このメッセージには Claude Code v2.1.198 以降が必要です。同じ `claude` 呼び出しで `--bg` を `-p` または `--print` と組み合わせました。`--bg` は [バックグラウンドセッション](/docs/ja/agent-view#from-your-shell) を開始し、後で `claude agents` で接続できます。一方、`--print` は [非対話的に](/docs/ja/headless) 実行され、`claude agents` が接続するインタラクティブセッションを開始しません。v2.1.198 より前は、この組み合わせは無言でバックグラウンドジョブを作成し、接続できなくなりました。

```text theme={null}
--bg と --print が競合しています。--print は `claude agents` が接続するインタラクティブセッションを開始しないため、ジョブは接続不可になります。プロンプトは位置引数です。--print を削除してください。`claude --bg '<task>'` です。
```

**対処方法：**

* `-p` または `--print` を削除してください。`--bg` はプロンプトを位置引数として受け取るため、`claude --bg "<task>"` が完全なコマンドです。[シェルから新しいエージェントをディスパッチする](/docs/ja/agent-view#from-your-shell) を参照してください。
* プロンプトを非対話的に実行し、バックグラウンドセッションを作成する代わりに結果を出力するには、`--bg` を削除して `claude -p "<task>"` を実行してください。

<h3 id="invalid-agents-configuration">
  無効な --agents 設定
</h3>

`--agents` に渡した値が無効なため、`claude` はセッションを開始する代わりに終了コード 1 で終了します。`--safe-mode`、`--resume`、または `--continue` を渡すか、[`CLAUDE_CODE_SAFE_MODE`](/docs/ja/env-vars#variables) を設定すると、Claude Code はその値をチェックせずにセッションを開始します。v2.1.242 より前は、Claude Code はセッションを開始し、読み込めない定義を省略していました。

```text theme={null}
Error: Invalid --agents configuration:
<what failed>
```

最初の行の後に続く内容は、値がどのように失敗したかによって異なります。Claude Code はこれらのチェックを順番に実行し、最初に失敗したもので停止します。値に 2 種類の問題がある場合、最初の問題を修正した後にのみ 2 番目の問題が表示されます。

1. 値が JSON として解析されない場合、Claude Code は JSON パーサー自身のメッセージを含む 1 つの `invalid JSON:` 行を出力します。
2. 解析されるが、エージェント定義が [CLI 定義サブエージェント](/docs/ja/sub-agents#choose-the-subagent-scope) のスキーマと一致しない場合、Claude Code は問題ごとに 1 行を出力します。
3. エージェント名が `-` で始まる場合、Claude Code は `<name>: agent names must not start with '-'` を出力します。

問題行が 20 行を超える場合、Claude Code は最初の 20 行を出力し、残りを `…and N more` に置き換えます。

**対処方法：**

* メッセージが列挙する各問題を修正してから、コマンドを再度実行してください。[CLI 定義サブエージェントが受け取るフィールド](/docs/ja/sub-agents#choose-the-subagent-scope) を参照してください。

<h3 id="cloud-sessions-cannot-be-created-from-a-restricted-session">
  クラウドセッションは --restricted セッションから作成できません
</h3>

[`--restricted`](/docs/ja/cli-reference#cli-flags) でセッションを開始すると、Claude Code は [クラウドセッション](/docs/ja/claude-code-on-the-web#from-terminal-to-web) をそこから作成することを拒否します。新しいセッションは制限されたプロセスの外で実行され、制限モードを強制しないためです。Claude Code はサーバーに接続する前にクライアント側で拒否するため、クラウドセッションは作成されません。

```text theme={null}
Cloud sessions cannot be created from a --restricted session: they would not enforce it.
```

**対処方法：**

* 制限されたセッションでタスクをローカルで実行してください。
* セッションの起動方法を制御できる場合は、`--restricted` なしで新しい `claude` セッションを開始し、そこからクラウドセッションを作成してください。

v2.1.248 より前は、Claude Code に `--restricted` フラグがなく、以前のバージョンはフラグ自体を不明なオプションエラーで拒否します。

<h3 id="the-json-schema-value-is-not-a-valid-json-schema">
  \--json-schema 値は有効な JSON Schema ではありません
</h3>

[`--json-schema`](/docs/ja/cli-reference#cli-flags) に渡したスキーマが [非対話モード](/docs/ja/headless#get-structured-output) で JSON Schema コンパイルに失敗したため、`claude` はプロンプトを実行する代わりに終了コード 1 で終了します。v2.1.205 より前は、無効なスキーマは構造化されていない出力を生成し、エラーはなく、`format` キーワードを使用したスキーマは無効として扱われていました。

```text theme={null}
Error: --json-schema is not a valid JSON Schema: data/type must be equal to one of the allowed values
```

2 番目のコロンの後のテキストはバリデータの診断で、失敗したキーワードまたは場所を示します。`"format": "email"` などの `format` キーワードを使用するスキーマは有効です。Claude Code は `format` を注釈として受け入れ、強制しません。

Claude Code はスキーマコンパイルの前に 2 つのチェックを実行します。解析不可能な JSON の値は `Error: --json-schema is not valid JSON` で拒否され、オブジェクトではない有効な JSON は `Error: --json-schema must be a JSON object` で拒否されます。

**対処方法：**

* 診断が示すスキーマの部分を修正してから、コマンドを再度実行してください。
* 診断が `schema too large` の場合は、スキーマのネストと `$ref` の再利用を減らしてください。
* [構造化された出力を取得する](/docs/ja/headless#get-structured-output) で動作するスキーマとコマンドを参照してください。

<h3 id="settings-file-exceeds-the-2mib-limit">
  設定ファイルが 2MiB の制限を超えています
</h3>

[`--settings`](/docs/ja/cli-reference#cli-flags) に渡したファイルが 2 MiB より大きいため、`claude` は起動時に終了コード 1 で終了し、読み込みません。設定ファイルは小さい JSON ドキュメントなので、このサイズのファイルは通常、パスが間違ったファイルを指していることを意味します。v2.1.214 より前は、Claude Code はサイズチェックなしでファイルを読み込み、数ギガバイトのファイルまたは `/dev/zero` などのデバイスファイルはメモリを無制限に増やしていました。

```text theme={null}
Error: Settings file exceeds the 2MiB limit: /path/to/settings.json
```

Claude Code は通常ファイルではない `--settings` パスも同じ方法で拒否します。デバイス、FIFO、またはソケットは `Error: Cannot use settings file (Not a regular file (device, FIFO, or socket))` の後にパスを報告し、ディレクトリは `EISDIR` 理由を報告します。

**対処方法：**

* `--settings` を 2 MiB 未満の通常の JSON 設定ファイルを指すようにしてください。[設定](/docs/ja/settings) でフォーマットを参照してください。

<h3 id="the-current-directory-no-longer-exists">
  現在のディレクトリが存在しなくなりました
</h3>

シェルがディレクトリに入った後、削除または移動されたディレクトリから `claude` を開始しました。例えば、別のシェルが削除した worktree または一時ディレクトリです。Claude Code は作業ディレクトリを読み取ることができないため、インタラクティブモードと [非対話モード](/docs/ja/headless) の両方で、セッションを開始する前に終了コード 1 で終了します。v2.1.239 より前は、Claude Code は縮小されたバンドルソースと生の `ENOENT ... uv_cwd` スタックを stderr に出力してクラッシュしていました。

```text theme={null}
The current directory no longer exists (it was deleted or moved). Start Claude Code from an existing directory.
error: The current working directory was deleted, so that command didn't work. Please cd into a different directory and try again.
```

原因と修正は両方の形式で同じです。

Claude Code が別の理由（権限の変更など）で作業ディレクトリを読み取ることができない場合、メッセージはエラーコードを示します。`Can't read the current directory (EACCES). Start Claude Code from a different directory.`

**対処方法：**

* ホームディレクトリやプロジェクトディレクトリなど、存在するディレクトリに変更してから、`claude` を再度実行してください。
* ディレクトリが同じパスで再作成された場合、シェルは削除されたものを保持しています。`cd "$PWD"` を実行するか、ディレクトリを出て再度入ってから、`claude` を再度実行してください。

<h3 id="workspace-not-trusted-when-starting-remote-control">
  Remote Control 開始時にワークスペースが信頼されていません
</h3>

[Remote Control](/docs/ja/remote-control) サーバーモードを `claude remote-control` またはそのエイリアス `claude rc` で開始しましたが、信頼していないディレクトリにあります。コマンドはワークスペース信頼ダイアログ自体を表示しないため、終了コード 1 で終了し、修正を示します。

```text theme={null}
Error: Workspace not trusted. Please run `claude` in /Users/you/project first to review and accept the workspace trust dialog.
```

ホームディレクトリでは、メッセージが異なります。ワークスペース信頼ダイアログはホームディレクトリの信頼を保存しないため、そこで受け入れることはこのチェックを満たすことができません。v2.1.214 より前は、ホームディレクトリは上記のメッセージを表示し、そのアドバイスはそこで成功できません。

```text theme={null}
Error: Workspace not trusted. /Users/you is your home directory, and for security home-directory trust is never saved, so running `claude` here first won't help. Run `claude rc` from a project directory instead (run `claude` there once to accept the trust dialog).
```

**対処方法：**

* ディレクトリで `claude` を実行し、[ワークスペース信頼ダイアログ](/docs/ja/permissions#project-allow-rules-and-workspace-trust) を受け入れてから、`claude remote-control` を再度実行してください。
* ホームディレクトリでは、プロジェクトディレクトリに変更して Remote Control をそこで開始してください。

<h3 id="not-carried-over-to-the-sessions-remote-control-starts">
  Remote Control が開始するセッションに引き継がれません
</h3>

[Remote Control](/docs/ja/remote-control) を `remote-control` 動詞の前にグローバル `claude` フラグで開始しました。これは Remote Control が開始するセッションを制限または設定するフラグです。例えば `--settings`、`--setting-sources`、`--permission-mode`、`--disallowed-tools`、または `--mcp-config` などです。動詞の前に配置されたフラグはこれらのセッションに到達しません。Claude Code は代わりに開始を拒否し、フラグを示します。

```text theme={null}
Error: `--settings` before `remote-control` is not carried over to the sessions Remote Control starts, so Remote Control refuses to start rather than drop it — remove it, and give Remote Control's own options after the verb (see `claude remote-control --help`).
```

Claude Code は `--verbose`、`--model`、またはラッパーが注入した `--session-id` や `--plugin-dir` など、削除しても害のないグローバルフラグは拒否しません。これらは無視され、Remote Control は開始します。

Claude Code はまだ無害として認識していないグローバルフラグについても拒否を開始するため、新しいリリースで追加されたフラグはそれが無害としてマークされるまで、このメッセージに表示される可能性があります。

**対処方法：**

* 動詞の前からフラグを削除し、[Remote Control 独自のオプション](/docs/ja/remote-control#start-a-remote-control-session) を後に渡してください。`claude remote-control --help` がそれらをリストします。
* 拒否されたフラグが `--permission-mode` の場合は、`claude remote-control --permission-mode <mode>` を実行して、Remote Control が開始するセッションの権限モードを設定してください。

v2.1.248 より前は、`claude remote-control` はグローバルフラグが最初に来たときに独自のフラグを受け入れず、コマンドは不明なオプションエラーで失敗しました。

<h3 id="claude-import-is-not-yet-available-in-this-build">
  claude import はこのビルドではまだ利用できません
</h3>

[`claude import`](/docs/ja/cli-reference#cli-commands) を実行し、Claude Code はインポートフローがオフになっていることを検出したため、コマンドはインポートを開始する代わりに終了コード 1 で終了します。v2.1.222 より前は、インポートフローがオフのビルドは `import` をプロンプトとして扱い、このメッセージを出力する代わりにインタラクティブセッションを開始していました。

```text theme={null}
`claude import` is not yet available in this build. Run `claude` and use /mcp or edit ~/.claude/settings.json directly.
```

Claude Code は `claude import` をフィーチャーフラグを通じてオンにします。このフラグは Anthropic から取得してディスクにキャッシュされます。このメッセージはキャッシュされた値がオフであることを意味します。原因は通常、以下のいずれかです。

* インストール後にセッションを開始していないため、Claude Code はまだフラグを取得していません。最初の `claude import` は、フィーチャーが利用可能な場合でもこれを出力できます。
* Amazon Bedrock、Google Cloud の Agent Platform、Microsoft Foundry、または Claude Platform on AWS を通じて Claude Code を使用しています。Claude Code はこれらのプロバイダーでフィーチャーフラグを取得しないため、`claude import` は利用不可のままです。
* `DISABLE_TELEMETRY`、`DO_NOT_TRACK`、`DISABLE_GROWTHBOOK`、または [`CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`](/docs/ja/env-vars) を設定しました。これらはフィーチャーフラグ取得をオフにするため、`claude import` は利用不可のままです。

**対処方法：**

* 新規インストールでは、`claude` を開始し、セッションが読み込まれるまで待ってから終了し、`claude import` を再度実行してください。
* フィーチャーフラグ取得がオフのままの場合は、設定を自分で設定してください。[`claude mcp add`](/docs/ja/mcp#installing-mcp-servers) で MCP サーバーを追加し、[`CLAUDE.md` ファイル](/docs/ja/memory#how-claude-md-files-load)、[スキルとコマンド](/docs/ja/skills#where-skills-live)、および [サブエージェント](/docs/ja/sub-agents#choose-the-subagent-scope) を作成してください。メッセージは `~/.claude/settings.json` も示します。`claude import` が引き継ぐ設定のうち、そのファイルは [権限モード](/docs/ja/settings-reference#permission-settings) のみを保持します。Claude Code はそこから MCP サーバーを読み込みません。

<h3 id="could-not-read-claude-code-config">
  Claude Code 設定を読み込めませんでした
</h3>

[`claude import`](/docs/ja/cli-reference#cli-commands) を実行しましたが、Claude Code はログインと プロジェクトごとの状態を保存する `~/.claude.json` を解析できませんでした。サブコマンドはその可用性をチェックするためにそのファイルを読み込みますが、インタラクティブセッションが表示する復旧ダイアログを表示しないため、終了コード 1 で終了します。v2.1.222 より前は、読み込み不可能な設定ファイルを持つ `claude import` はインタラクティブセッションを開始し、その復旧ダイアログがファイルを処理していました。

```text theme={null}
Could not read Claude Code config — run `claude` with no arguments to recover it.
```

**対処方法：**

* 引数なしで `claude` を実行してください。Claude Code は無効なファイルを検出し、リセットを提供します。その後、`claude import` を再度実行してください。
* 手動で編集した内容を保持するには、エディタで `~/.claude.json` の JSON 構文を修正してから、`claude import` を再度実行してください。

<h3 id="could-not-import-a-server-from-claude-desktop">
  Claude Desktop からサーバーをインポートできませんでした
</h3>

Claude Code は `claude mcp add-from-claude-desktop` で選択したサーバーの 1 つを追加できませんでした。コマンドは他の選択されたサーバーをインポートし、追加できなかったサーバーごとに 1 行を出力します。v2.1.205 より前は、失敗した最初のサーバーがインポートを停止し、選択されたサーバーは追加されませんでした。

```text theme={null}
Could not import my server: Invalid name my server. Names can only contain letters, numbers, hyphens, and underscores.
```

サーバー名の後のテキストは理由です。最も一般的なのは名前チェックです。Claude Desktop はサーバー名に空白やピリオドなどの文字を許可しますが、`claude mcp` はそれらを文字、数字、ハイフン、アンダースコアに制限します。その他の理由には、検証に失敗したサーバー設定と、組織の [MCP ポリシー](/docs/ja/managed-mcp) によってブロックされたサーバーが含まれます。

**対処方法：**

* `claude_desktop_config.json` でサーバーの名前を変更して、文字、数字、ハイフン、アンダースコアのみを使用してから、`claude mcp add-from-claude-desktop` を再度実行してください。
* そのサーバーを `claude mcp add` または `claude mcp add-json` で有効な名前の下に直接追加してください。[Claude Desktop から MCP サーバーをインポートする](/docs/ja/mcp#import-mcp-servers-from-claude-desktop) を参照してください。

<h3 id="anthropic-hosted-and-doesnt-support-local-oauth">
  サーバーは Anthropic ホストで、ローカル OAuth をサポートしていません
</h3>

MCP サーバーのサインインを開始しましたが、その URL は Anthropic ホストのコネクタホストを指しており、サードパーティの ID プロバイダーを通じて認証します。これらのホストには `microsoft365.mcp.claude.com`、`gmail.mcp.claude.com`、および `gcal.mcp.claude.com` が含まれます。Claude Code は `/mcp` パネルと `claude mcp login` の両方からこれらのホストのローカル OAuth フローを開始することを拒否します。[それらのサインインは claude.ai を通じてのみ機能するため](/docs/ja/mcp#use-mcp-servers-from-claude-ai)です。

```text theme={null}
"gmail" is Anthropic-hosted and doesn't support local OAuth. Connect it via Settings → Connectors on claude.ai (requires `claude login`), then it'll be available here automatically.
```

Claude Code はこれらのホストを URL で照合するため、`claude mcp add` または `.mcp.json` で追加したサーバーがそれらの 1 つを指している場合、メッセージが表示されます。

**対処方法：**

* `claude mcp remove <name>` でエントリを削除して、同じ URL の claude.ai コネクタを隠すことができないようにしてください。
* 削除した後、[claude.ai/customize/connectors](https://claude.ai/customize/connectors) で、Claude Code で使用するアカウントにサインインしながらサービスを接続してください。接続されると、アクティブな認証方法が claude.ai サブスクリプションログインの場合、[コネクタは Claude Code に自動的に表示されます](/docs/ja/mcp#use-mcp-servers-from-claude-ai)。

<h3 id="server-rejected-the-authorization-header-minted-by-the-configured-headershelper">
  サーバーは設定された headersHelper によって作成された Authorization ヘッダーを拒否しました
</h3>

[`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) が `Authorization` ヘッダーを提供する MCP サーバーが HTTP 401 または 403 で接続に応答したため、Claude Code は接続を失敗として報告します。ヘルパーが `Authorization` ヘッダーを提供するため、Claude Code は [OAuth にフォールバック](/docs/ja/mcp#authenticate-with-remote-mcp-servers) しません。

```text theme={null}
Server rejected the Authorization header minted by the configured headersHelper (HTTP 401). Check that the helper command returns a valid credential for this MCP endpoint — OAuth fallback is disabled when the helper supplies Authorization.
```

Claude Code は各接続試行でヘルパーを再実行するため、トークンローテーションレースなどの一時的な拒否の後の再試行は、新しい認証情報で成功する可能性があります。

**対処方法：**

* `headersHelper` コマンドを Claude Code が実行する方法で自分で実行してください。[Claude Code が実行するディレクトリ](/docs/ja/mcp#where-the-helper-runs) から、[Claude Code が設定する環境変数](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) を使用して、[Claude Code が削除する認証情報変数](/docs/ja/mcp#which-variables-a-helper-can-read) なしで実行してください。プロジェクト `.mcp.json`、プラグイン、またはプロジェクトエージェントファイルからのサーバーの場合です。サーバーのエンドポイントが受け入れる `Authorization` 値を出力することを確認してください。
* ヘルパーまたはその認証情報ソースを修正した後、`/mcp` でサーバーを選択し、**Reconnect** を選択してください。

v2.1.248 より前は、Claude Code はヘルパーが `Authorization` ヘッダーを提供するサーバーの OAuth ディスカバリーを実行していました。そのディスカバリーは、拒否された認証情報を報告する代わりに `Incompatible auth server: does not support dynamic client registration` で失敗する可能性がありました。

<h3 id="mcp-permission-prompt-tool-not-found">
  MCP 権限プロンプトツールが見つかりません
</h3>

[`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) に渡したツールは、実行が最初に権限決定を必要とした時点で接続された MCP ツールの中にありませんでした。サーバーが接続されなかったか、接続されたサーバーがその名前のツールを公開していないためです。Claude Code はまだプロンプトを送信します。[非対話](/docs/ja/headless) 実行は、承認が必要な最初のツール呼び出しでこのエラーで終了し、終了コード 1 で終了するため、リクエストが行われたにもかかわらず答えを生成しません。最初のプロンプトの前に、Claude Code は [`MCP_TIMEOUT`](/docs/ja/env-vars) で設定されたサーバーごとの接続タイムアウト 30 秒まで、そのサーバーが接続されるのを待ちます。v2.1.206 より前は、起動は接続の完了を待たなかったため、遅く開始しても健全なサーバーはこのエラーを生成していました。

```text theme={null}
Error: MCP tool mcp__permissions__approve (passed via --permission-prompt-tool) not found. Available MCP tools: none
```

`Available MCP tools:` の後のリストは、待機が終了したときに接続されていた MCP ツールを示します。

**対処方法：**

* サーバーが開始して接続されたままであることを確認してください。同じディレクトリで `claude mcp list` を実行し、サーバーが接続済みとしてリストされていることを確認してください。
* ツール名がサーバーが公開する `mcp__<server>__<tool>` 名と一致することを確認してください。
* サーバーが開始するのに 30 秒以上かかる場合は、[`MCP_TIMEOUT`](/docs/ja/env-vars) を上げてください。

<h3 id="security-review-fails-without-origin-head">
  /security-review は origin/HEAD なしで失敗します
</h3>

[`/security-review`](/docs/ja/commands#all-commands) はブランチを `origin/HEAD` に対して diff することで、レビューコンテキストを構築します。`origin/HEAD` は、`origin` リモートのデフォルトブランチがどれであるかを記録するローカル ref です。その ref が存在しない場合、diff を収集する git コマンドは失敗し、レビューは開始する前に停止します。

```text theme={null}
Error: Shell command failed for pattern "!`git diff --name-only origin/HEAD...`": [stderr]
fatal: ambiguous argument 'origin/HEAD...': unknown revision or path not in the working tree.
Use '---- to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
```

引用されたコマンドは実行ごとに異なります。レビューは `origin/HEAD` に対して複数の `git` コマンドを同時に開始し、最初に失敗したものを報告するため、`git log` または別の `git diff` が表示される場合があります。Git は、リモートのデフォルトブランチがリモートによってアドバタイズされ、フェッチ refspec でカバーされている場合にのみ ref を作成します。リモートの完全な `git clone` はコミットを持つため、両方の条件を満たします。シングルブランチと CI チェックアウトはフェッチ refspec が狭すぎます。サーバー側の HEAD は誰も push していないブランチを指しており、リポジトリに `origin` リモートがないか、フェッチしたことがない場合は、どちらも提供しません。

Claude Code は、[動的コンテキストを注入](/docs/ja/skills#when-an-injected-command-fails) するスキルについても同じエラーを表示します。失敗した注入コマンドはそのスキルの呼び出しを中止します。コマンドが実行される前に 2 つの兄弟文字列が発火します。

* `Shell command permission check failed for pattern "..."`: コマンドの権限チェックが許可以外を返しました。注入コマンドはプロンプトを表示しないため、呼び出しは質問なく中止されます。ルールが一致しないコマンドを [`allowed-tools`](/docs/ja/skills#pre-approve-tools-for-a-skill) で事前承認してください。一致する ask または deny ルールは、`allowed-tools` に関係なく呼び出しを中止します。
* ``Skill <name> requires bash (`shell: bash` in frontmatter) but Git Bash was not found``: スキルの frontmatter は bash を要求していますが、マシンにはありません。Git for Windows をインストールするか、frontmatter を `shell: powershell` に変更してください。[注入コマンドの実行方法](/docs/ja/skills#how-injected-commands-run) を参照してください。

**対処方法：**

* リモートのデフォルトブランチを指定して ref を作成してください。`git remote set-head origin <default-branch>`。これは、ローカル追跡 ref `origin/<default-branch>` が存在するときはいつでも機能します。存在しない場合（シングルブランチクローンなど）は、最初にブランチをフェッチしてください。`git remote set-branches --add origin <branch>` を実行してから、`git fetch origin` を実行してから、set-head コマンドを再度実行してください。`/security-review` を再度実行してください。
* ブランチを指定したくない場合は、`git fetch origin` を実行してから `git remote set-head origin --auto` を実行します。これはリモートにデフォルトブランチを尋ねます。リモートがデフォルトブランチをアドバタイズしない場合（空であるか、HEAD が誰も push していないブランチを指している場合）、`error: Cannot determine remote HEAD` で失敗します。代わりにブランチを明示的に指定してください。クローンがそのブランチをフェッチしない場合、`error: Not a valid ref` で失敗します。上記のように refspec を広げてください。
* リポジトリにリモートがない場合は、`git remote add origin <url>` で追加してからフェッチしてから ref を作成してください。リモートが空の場合は、`git push -u origin HEAD` でブランチを push してから、set-head コマンドでそのブランチを指定してください。`origin/HEAD` はその後、push したばかりのブランチを指すため、`/security-review` はブランチがそれから分岐するまで空の diff を見ます。

<h3 id="input-must-be-provided-when-using-print">
  \--print を使用する場合は入力を提供する必要があります
</h3>

ベアの `claude` は、インタラクティブ UI を開始するために stdout がターミナルである必要があります。stdout がリダイレクトされるか、PowerShell ISE や一部の IDE 出力ペインなど、コンソールが実際のターミナルでない場合、`claude` は代わりに [非対話的に](/docs/ja/headless) 実行されます。これは `claude -p` と同じモードで、プロンプトが必要です。そのため、メッセージはフラグを渡さなかった場合でも `--print` を示します。プロンプトなしで `-p`/`--print` を渡し、stdin に何もパイプされていない場合は、どこでも同じエラーが発生します。

```text theme={null}
Error: Input must be provided either through stdin or as a prompt argument when using --print
```

**対処方法：**

* インタラクティブ使用の場合は、実際のターミナルで `claude` を実行してください。Windows Terminal または PowerShell コンソール（ISE ではなく）、IDE の統合ターミナル（出力ペインではなく）。
* ワンショット使用の場合は、プロンプトを渡してください。`claude -p "your question"`、または `echo "your question" | claude -p` でパイプしてください。

<h3 id="input-contained-only-whitespace">
  入力は空白のみでした
</h3>

[非対話モード](/docs/ja/headless) では、Claude Code は空白、タブ、または改行のみで構成されるプロンプトを拒否します。API は目に見えるテキストのないメッセージを拒否するためです。表示されるメッセージは、空白のプロンプトがどこから来たかによって異なります。

* **`claude -p` のプロンプト引数またはパイプされた stdin**: `claude` は `Error: Input contained only whitespace. Provide a prompt with text through stdin or as a prompt argument when using --print` で終了します。
* **実行中の `--input-format stream-json` または [Agent SDK](/docs/ja/agent-sdk/overview) セッションに送信されたメッセージ**: Claude Code はモデルを呼び出さずにターンを終了し、セッションは使用可能なままです。拒否は情報メッセージとしてターンの結果テキストとして到着します。`Blank prompt — the message was only whitespace, so nothing was sent to the model.`

v2.1.229 より前は、Claude Code は空白のみのメッセージを API に送信し、API は 400 エラーでリクエストを拒否していました。

**対処方法：**

* プロンプトに目に見えるテキストを含めてください。スクリプトが変数またはファイルからプロンプトを構築する場合は、Claude Code を呼び出す前にソースが空でないことを確認してください。

<h3 id="unknown-command">
  不明なコマンド
</h3>

このセッションのコマンドと一致しない `/` 名を送信したため、Claude Code は何も実行する代わりに名前を報告します。

```text theme={null}
Unknown command: /hepl. Did you mean /help?
```

Claude Code は、このセッションのメニューにリストされている最も近いコマンド名またはエイリアスを提案します。何も近い場合、メッセージは名前の後で終了します。原因は通常、以下のいずれかです。

* `/hepl` から `/help` への typo などのタイプミス。[コマンドメニューが入力と一致する方法](/docs/ja/commands#how-the-command-menu-matches-what-you-type) は、送信する前に近い一致を選択することをカバーしています。
* 存在するが、プラットフォーム、プラン、または認証方法などの要件が満たされていないため、このセッションで利用できないコマンド。[`/web-setup`](/docs/ja/web-quickstart#web-setup-shows-no-commands-match-or-unknown-command) と [`/schedule`](/docs/ja/routines#schedule-returns-unknown-command) のトラブルシューティングエントリは、2 つの一般的なケースを説明しています。組織のポリシーがそれらを無効にする場合、一部のコマンドは独自のメッセージで応答します。
* [プラグイン](/docs/ja/plugins) または [MCP サーバー](/docs/ja/mcp#use-mcp-prompts-as-commands) からのコマンドで、このセッションにインストールまたは接続されていません。

Claude Code は `/` で始まるすべてのプロンプトをコマンドとして扱うわけではありません。最初の単語が `/` の後に句読点で始まる場合（Lean ドキュメントコメントを開く `/--` など）、またはパス（`/var/log/syslog` など）の場合、プロンプトを通常のメッセージとして Claude に送信します。

v2.1.236 より前は、コマンドメニューが入力した名前の近い一致をリストしている間に `Enter` を押した場合、Claude Code はその一致を実行したため、`/hepl` などのタイプミスはこのメッセージを生成する代わりに `/help` を実行していました。

**対処方法：**

* 提案された名前を実行するか、`/` の後に名前の一部を入力して、このセッションで利用可能なものを確認してください。
* Claude Code が文書化されたコマンドを不明として報告する場合は、[コマンドリファレンス](/docs/ja/commands) でその行を確認して、それが示す要件を確認してください。

<h3 id="diff-is-too-large-for-ultrareview">
  Diff は ultrareview には大きすぎます
</h3>

ブランチとベースブランチ間の diff（コミットされていない変更とステージされた変更を含む）が [ultrareview](/docs/ja/ultrareview) のサイズ制限を超えているため、`/code-review ultra` と `claude ultrareview` サブコマンドはクラウドセッションが開始される前にレビューを拒否します。拒否されたレビューは無料実行を使用せず、使用クレジットを請求しません。メッセージは有効な制限、diff のサイズ、および最も変更された行に貢献するファイルを示します。v2.1.216 より前は、メッセージは生の diff 統計のみを表示していました。

```text theme={null}
Diff is too large for ultrareview: 812 files, 96,410 lines changed (limits: 500 files, 8,000 lines). Largest files: package-lock.json (41,904 lines), dist/bundle.js (18,210 lines), src/generated/api.ts (9,876 lines). Pass a closer base branch (`/code-review ultra <branch>`) to narrow the scope, or split the change.
```

プルリクエストをレビューすると、同じ制限が適用されます。そのメッセージの形式は `PR #<N> is too large for ultrareview` で始まり、PR のファイルと行数を示します。

**対処方法：**

* より近いベースブランチ（`/code-review ultra develop` など）を渡して、レビューがそのブランチに対する diff のみをカバーするようにしてください。
* 変更を小さなブランチに分割し、それぞれをレビューしてください。メッセージが示すファイルは最も変更された行に貢献するため、それらを独自のブランチに移動することから始めてください。

<h3 id="could-not-find-merge-base-with-the-base-branch">
  ベースブランチとのマージベースが見つかりませんでした
</h3>

`/code-review ultra` と `claude ultrareview` サブコマンドは、ブランチとベースブランチ間の diff をレビューします。これには 2 つが共有するコミットが必要です。`git merge-base` が見つからない場合、Claude Code はクラウドセッションが開始される前にレビューを拒否します。Claude Code が完全であることを確認できるクローンでは、少なくとも 1 つのブランチがあり、代わりに [すべての追跡ファイルをレビュー](/docs/ja/ultrareview#diff-limits-and-fallbacks) することにフォールバックします。ベースブランチが見つからない場合、Claude Code がクローンが完全であることを確認できない場合、または SHA-256 オブジェクト形式など、全体ツリー diff が不可能なまれなリポジトリでこの拒否が表示されます。

```text theme={null}
Could not find merge-base with main. Pass the base branch explicitly (e.g. `/code-review ultra develop`) or make sure you're in a git repo with a main branch.
```

最初の文の後のヒントは、Claude Code が観察したものに依存します。

* **ベースブランチを渡さなかった**: Claude Code はリポジトリのデフォルトブランチと比較し、上記の例のように明示的にベースを渡すことを提案します。
* **クローンに既にあったベースブランチを渡した**: ヒントは ``Make sure <branch> exists locally or on origin (try `git fetch origin <branch>`)`` を読みます。
* **クローンにはなかったベースブランチを渡した**: Claude Code は比較する前に origin からフェッチしました。ヒントは ``<branch> was fetched from origin but shares no history with HEAD. If another branch is your real base, pass it explicitly (`/code-review ultra <branch>`)``を読みます。Claude Code がクローンが浅いかどうかを判断できない場合、代わりに `git fetch --unshallow origin` を提案します。v2.1.221 より前は、フェッチされたすべてのベースブランチについて `git fetch --unshallow origin` を提案し、完全なクローンではそのコマンドは `fatal: --unshallow on a complete repository does not make sense` で失敗します。

**対処方法：**

* 別のブランチが実際のベースの場合は、明示的に渡してください。`/code-review ultra <branch>`
* クローンに完全な履歴がない可能性がある場合は、`git fetch --unshallow origin` を実行してレビューを再度実行してください。

<h3 id="your-checkout-has-no-branches">
  チェックアウトにはブランチがありません
</h3>

チェックアウトはコミットを持つことができますが、ブランチはありません。`git init` の後に `git fetch <url>` と `git checkout FETCH_HEAD` を実行すると、ref のない分離 HEAD が得られます。Claude Code はリポジトリを git バンドルとしてパッケージ化して [ultrareview](/docs/ja/ultrareview) 用にアップロードし、ブランチまたは他の ref がないリポジトリをバンドルできないため、`/code-review ultra` と `claude ultrareview` サブコマンドはクラウドセッションが開始される前にレビューを拒否します。

```text theme={null}
Your checkout has no branches (detached HEAD only), which cloud review can't bundle. Create one first — `git checkout -b <name>` — then rerun /code-review ultra.
```

v2.1.221 より前は、Claude Code はこのチェックアウトのすべての追跡ファイルをレビューしようとし、アップロードは失敗していました。

**対処方法：**

* 現在のコミットでブランチを作成してください。`git checkout -b <name>`、その後レビューを再度実行してください。

<h3 id="no-github-account-is-connected-to-your-claude-account">
  GitHub アカウントが Claude アカウントに接続されていません
</h3>

`/code-review ultra <PR#>` または `claude ultrareview <PR#>` を実行し、クラウドセッションを作成する前に Claude Code はサーバーに [Claude アカウントに接続された GitHub アカウント](/docs/ja/ultrareview#review-a-pull-request) が PR のリポジトリに到達できるかどうかを尋ねます。アカウントが接続されていないか、接続が期限切れになったため、クラウドクローンは失敗し、Claude Code は起動を拒否します。Claude Code は無料実行を使用したり、使用クレジットを請求したりしません。

```text theme={null}
Ultrareview clones <owner>/<repo> in the cloud with the GitHub account connected to your Claude account, and none is connected (or the connection expired). To fix: run /web-setup to reuse your GitHub CLI login, or connect an account at https://claude.ai/code/onboarding?step=alt-auth — then re-run /code-review ultra 1234 (allow a minute after connecting).
```

[`/web-setup`](/docs/ja/web-quickstart#connect-from-your-terminal) がセッションで利用できない場合、メッセージは claude.ai リンクのみを示します。

**対処方法：**

* `/web-setup` を実行して GitHub CLI ログインを Claude アカウントに接続するか、[claude.ai/code/onboarding](https://claude.ai/code/onboarding?step=alt-auth) でアカウントを接続してください。
* 接続後 1 分後にレビューを再度実行してください。

v2.1.248 より前は、Claude Code は起動前にこれをチェックしませんでした。

<h3 id="your-connected-github-account-cant-see-the-repository">
  接続された GitHub アカウントはリポジトリを見ることができません
</h3>

`/code-review ultra <PR#>` または `claude ultrareview <PR#>` を実行し、[Claude アカウントに接続された GitHub アカウント](/docs/ja/ultrareview#review-a-pull-request) が PR のリポジトリを読み取ることができないため、クラウドクローンは失敗し、Claude Code は起動を拒否します。Claude Code は無料実行を使用したり、使用クレジットを請求したりしません。

```text theme={null}
Your connected GitHub account can't see <owner>/<repo> — usually the Claude GitHub app isn't installed on <owner> or wasn't granted this repo (web-connected accounts need it for private repos), or a different GitHub account is connected. To fix: run /web-setup to reuse your GitHub CLI login, or install the app at https://github.com/apps/claude/installations/new — then re-run /code-review ultra 1234.
```

[`/web-setup`](/docs/ja/web-quickstart#connect-from-your-terminal) がセッションで利用できない場合、メッセージはアプリインストールのみを示します。

**対処方法：**

* ローカル `gh` CLI がリポジトリを読み取ることができる場合は、`/web-setup` を実行してそのログインを Claude アカウントに接続してください。
* 変更後にレビューを再度実行してください。

v2.1.248 より前は、Claude Code は起動前にこれをチェックしませんでした。

<h3 id="the-github-app-preflight-failed-transiently">
  GitHub App プリフライトが一時的に失敗しました
</h3>

ローカルリポジトリから [クラウドセッション](/docs/ja/claude-code-on-the-web) を開始し、2 つのステップが一緒に失敗しました。Claude Code はリポジトリのバンドルを構築またはアップロードできませんでした。アップロードの前に、クラウドサービスが GitHub からリポジトリをクローンできるかどうかを確認し、確定的な答えではなく、再試行で解決できるエラーで終了しました。ネットワークエラー、タイムアウト、または一時的なサーバーエラーなどです。完全なメッセージは、バンドルを停止したもの（例えば `Could not upload repo bundle (<error>)` など）で始まり、プリフライト文で終わります。

```text theme={null}
Could not upload repo bundle (<error>). The GitHub App preflight failed transiently (network or service hiccup) — retry in a moment to start from GitHub instead
```

**対処方法：**

* しばらく後にコマンドを再度実行してください。GitHub チェックが成功すると、Claude Code は GitHub クローンから開始できるため、失敗したアップロードはもはや起動をブロックしません。
* 再試行が失敗し続ける場合、メッセージの開始はアップロードを停止したものを示します。その原因が修正できるものの場合は、セッションがローカルリポジトリから代わりに開始できるように修正してください。

v2.1.251 より前は、Claude Code は GitHub チェックが一時的に失敗した場合でも `Please set up GitHub on https://claude.ai/code` でメッセージを終了し、セットアップアドバイスは一時的な失敗をクリアできません。

<h3 id="failed-to-resume-the-conversation">
  会話の再開に失敗しました
</h3>

Claude Code は [`claude --resume` ピッカー](/docs/ja/sessions#use-the-session-picker) から選択したセッションの保存されたトランスクリプトを読み込むか処理できなかったため、部分的に読み込まれた状態で続行する代わりにプロセスを終了します。メッセージには再試行するコマンドが含まれます。

```text theme={null}
Failed to resume the conversation.
Run claude --resume <session-id> to retry, or claude to start a new session.
```

Claude Code はメッセージを表示した後、終了コード 1 で終了します。実行中のセッション内の `/resume` ピッカーは、会話で `Failed to resume conversation` を報告し、現在のセッションは実行を続けます。v2.1.216 より前は、`claude --resume` ピッカーからの失敗した再開は `Resuming conversation…` スピナーで無期限に留まり、このメッセージを表示する代わりにメッセージを表示していました。

**対処方法：**

* メッセージからセッション ID を使用して `claude --resume <session-id>` を実行して再試行してください。
* 再試行が再度失敗する場合は、`claude` を実行して新しいセッションを開始してください。

<h3 id="no-conversation-found-with-the-session-id">
  セッション ID で会話が見つかりません
</h3>

セッション ID を `claude --resume <session-id>` に渡し、保存されたトランスクリプトが一致しませんでした。

```text theme={null}
No conversation found with session ID: <session-id>
```

Claude Code はメッセージを表示した後、終了コード 1 で終了します。Claude Code は [現在のプロジェクトを最初に検索し、このマシンのすべての他のプロジェクトを検索](/docs/ja/sessions#resume-a-session) します。v2.1.223 より前は、ルックアップは現在のプロジェクトディレクトリとその git worktrees で停止したため、セッションが最後に機能したディレクトリから再開してください。

一般的な原因：

* **タイプミスされた ID**: 非対話的な実行の場合、ID は [`--output-format json` 出力](/docs/ja/headless#get-structured-output) の `session_id` フィールドです。
* **削除されたトランスクリプト**: Claude Code は [保持期間](/docs/ja/sessions#where-transcripts-are-stored)（デフォルトでは 30 日）の後にトランスクリプトを削除し、[保持スイープルール](/docs/ja/claude-directory#cleaned-up-automatically) に従います。
* **別のマシン**: Claude Code はトランスクリプトをローカルに保存するため、セッションが実行されたマシンでセッションを再開してください。
* **重複コピー**: `~/.claude/projects` の下にプロジェクトディレクトリをコピーして 2 つのトランスクリプトが同じ ID を持つ場合、Claude Code はこのメッセージを報告し、任意に 1 つのコピーを再開する代わりにメッセージを報告します。

**対処方法：**

* インタラクティブセッションの場合は、`claude --resume` で [セッションピッカー](/docs/ja/sessions#use-the-session-picker) を開き、`Ctrl+A` を押してこのマシンのすべてのプロジェクトに拡張してから、セッションを選択してください。
* `claude -p` または [Agent SDK](/docs/ja/agent-sdk/overview) で作成されたセッションはピッカーに表示されないため、元の実行が出力した `session_id` に対して ID を再度チェックしてください。

<h3 id="cannot-switch-renderers-in-this-session">
  このセッションではレンダラーを切り替えることができません
</h3>

レンダラーを切り替えると、Claude Code はプロセスを再起動します。Claude Code が再起動を拒否するセッションで [`/tui`](/docs/ja/fullscreen#enable-fullscreen-rendering) を実行したため、切り替わらず、何も保存されません。表示されるメッセージは原因を示します。

* `Cannot switch renderers while work is running in the background`: バックグラウンドで実行中の作業があり、再起動は放棄されます。例えば、バックグラウンドシェルまたはサブエージェント。[`/tasks`](/docs/ja/commands) で作業が完了するまで待つか、停止してから、`/tui fullscreen` または `/tui default` を再度実行してください。
* `Cannot switch renderers in this session`: セッションには、再起動が引き継ぐことができない制限があります。v2.1.234 より前は、Claude Code は再起動し、再起動されたセッションはそれらなしで実行されていました。

制限メッセージでは、括弧内の部分は Claude Code が見つけた制限を示します。

```text theme={null}
Cannot switch renderers in this session — it has restrictions a restart can't carry over (permission rules set for this session only). Nothing was changed. Running /tui fullscreen in a session started without them switches every later session too.
```

メッセージが括弧内に表示できる各理由：

* `launch flags: a custom system prompt, a tool allowlist, or restricted settings`: Claude Code が再起動されたプロセスに渡さないフラグでセッションを開始しました。これらのフラグには [`--system-prompt`](/docs/ja/cli-reference#cli-flags)、`--system-prompt-file`、`--append-system-prompt-file`、[`--tools`](/docs/ja/cli-reference#cli-flags) allowlist、[`--setting-sources`](/docs/ja/cli-reference#cli-flags)、および [`--permission-prompt-tool`](/docs/ja/cli-reference#cli-flags) が含まれます。
* `permission rules set for this session only`: フック または SDK 呼び出し元からの [権限更新](/docs/ja/hooks#permission-update-entries) は、`session` 宛先を持つ deny または ask ルールを追加しました。セッションスコープの allow ルールは拒否をトリガーしません。再起動はそれらを削除し、Claude Code は代わりに再度プロンプトを表示します。
* `ask-before-running rules with no command-line form`: フック または SDK 呼び出し元からの権限更新は、Claude Code が `--allowed-tools` および `--disallowed-tools` として渡すルールと共に ask ルールを追加しました。ask ルールのフラグは存在しません。
* `permission rules a command line cannot carry intact` および `added directories a command line cannot carry intact`: 権限更新はセッション中にルールまたはディレクトリパスを追加しました。再起動されたプロセスのコマンドラインはそのテキストを同じ値として引き継ぐことができません。

**対処方法：**

* これらの制限なしで開始されたセッションで、`/tui fullscreen` または `/tui default` を実行して戻してください。Claude Code は [`tui` 設定](/docs/ja/settings-reference#tui) をそこに保存します。

<h3 id="terminal-setup-left-your-zed-keymap-unchanged">
  /terminal-setup は Zed キーマップを変更しないままにしました
</h3>

Zed で [`/terminal-setup`](/docs/ja/terminal-config#enter-multiline-prompts) を実行し、Claude Code は Zed `keymap.json` への更新を完了できなかったため、ファイルはそのままにしました。

各メッセージはキーマップへのパスを示し、自分で追加するキーバインディングブロックで終わります。

```text theme={null}
Couldn't update your Zed keymap, so it was left unchanged.
To add the binding yourself, add this block to the keymap array in <path to keymap.json>:
{ "context": "Terminal", "bindings": { "shift-enter": ["terminal::SendText", "\u001b\r"] } }
```

メッセージの最初の行は原因を示します。

* `Couldn't read your Zed keymap, so it was left unchanged.`: Claude Code はファイルを読み込むことができませんでした。例えば、ファイル権限のため。
* `Your Zed keymap isn't a readable list of keybindings, so it was left unchanged.`: ファイルは正常に読み込まれましたが、`//` コメントと末尾のコンマが許可されていても、キーバインディングブロックの配列として解析されません。
* `Couldn't back up your Zed keymap; not modifying it.`: Claude Code はファイルを `.bak` バックアップにコピーできませんでした。そのため、何も変更されませんでした。
* `Couldn't update your Zed keymap, so it was left unchanged.`: マージされた結果はバインディングを実行するキーマップとして有効として検証されなかったため、Claude Code は書き込む代わりに破棄しました。重複したキーを持つキーバインディングブロックはこれを引き起こす可能性があります。

**対処方法：**

* メッセージのブロックをメッセージが示すパスの `keymap.json` のトップレベル配列にコピーしてください。
* `isn't a readable list of keybindings` の場合は、構文エラーを修正するか、ファイルのトップレベル値を配列にしてから、`/terminal-setup` を再度実行してください。

v2.1.247 より前は、`/terminal-setup` は `//` コメントまたは末尾のコンマを使用する Zed キーマップを解析できず、独自のバインディングのみでファイル全体を置き換え、バインディングがインストールされたと報告していました。以前のバージョンが置き換えたキーマップを復元するには、[マルチラインプロンプトを入力する](/docs/ja/terminal-config#enter-multiline-prompts) の下で説明されている `.bak` バックアップファイルを使用してください。

<h3 id="skill-usage-reports-are-not-available-on-this-connection">
  スキル使用レポートはこの接続では利用できません
</h3>

[Remote Control](/docs/ja/remote-control) 経由で、電話またはブラウザから [`/skill-doctor`](/docs/ja/skills#find-unused-skills) を実行しました。Claude Code は Remote Control 経由でスキル使用レポートを送信せず、代わりにこのメッセージで応答します。

```text theme={null}
Skill usage reports are not available on this connection.
```

**対処方法：**

* セッションが実行されているマシンのターミナルで `/skill-doctor` を実行するか、`claude -p "/skill-doctor"` をそこで実行してください。

<h2 id="plugin-errors">
  プラグインエラー
</h2>

これらのエラーは、[プラグイン](/docs/ja/plugins)と[マーケットプレイス](/docs/ja/plugin-marketplaces)の設定から発生します。このページのメッセージを生成しないプラグインの問題（マーケットプレイス URL が読み込まれない、またはプラグインがインストールされても表示されないなど）については、[プラグインのトラブルシューティング](/docs/ja/discover-plugins#troubleshooting)を参照してください。

<h3 id="marketplace-is-registered-from-an-untrusted-source">
  マーケットプレイスが信頼されていないソースから登録されている
</h3>

マーケットプレイスは、[公式 Anthropic マーケットプレイス用に予約されている名前](/docs/ja/plugin-marketplaces#marketplace-schema)で登録されていますが、登録されたソースが `anthropics` GitHub リポジトリではありません。Claude Code は、マーケットプレイスを読み込むか更新するたびに予約名を再確認するため、マーケットプレイスとそこからインストールされたプラグインの読み込みが停止します。v2.1.205 より前は、マーケットプレイスが追加されたときにのみ名前がチェックされたため、その名前が予約される前に登録されたエントリは読み込み続けていました。

```text theme={null}
Marketplace "claude-community" is registered from an untrusted source: The name 'claude-community' is reserved for official Anthropic marketplaces. Only repositories from 'github.com/anthropics/' can use this name. To fix it, remove the marketplace and re-add it from the official source.
```

ソースが GitHub リポジトリまたは Git URL ではなく、ローカルディレクトリなどの場合、中央の文は `can only be used with GitHub sources from the 'anthropics' organization` の代わりに読み込まれます。`claude plugin marketplace add` は同じチェックを実行し、予約名を拒否して `Failed to add marketplace:` の後に同じ予約名の文が続きます。

**対処方法：**

* マーケットプレイスが既に登録されている場合は、`claude plugin marketplace remove <name>` を実行してから、公式の `github.com/anthropics` リポジトリから再度追加してください
* 名前が予約される前にその名前を使用していたサードパーティマーケットプレイスを公開する場合は、名前を変更し、ユーザーにあなたのソースから再度追加するよう依頼してください
* [マーケットプレイススキーマ](/docs/ja/plugin-marketplaces#marketplace-schema)の予約名リストを参照してください

<h3 id="plugin-command-references-user-config">
  プラグインコマンドがシェルコマンドで user\_config を参照している
</h3>

プラグインフック、[monitor](/docs/ja/plugins-reference#monitors)、または MCP [`headersHelper`](/docs/ja/mcp#use-dynamic-headers-for-custom-authentication) コマンドが `${user_config.KEY}` [プラグインオプション](/docs/ja/plugins-reference#user-configuration)を参照し、置換された文字列がシェルに渡されます。`$(...)` 、バッククォート、または `;` を含む設定値はそこでコードとして実行されるため、Claude Code は値を置換する代わりにコンポーネントの起動を拒否します。チェックはコマンドテンプレートで実行されるため、値がまだ設定されていない場合でもエラーが表示されます。v2.1.207 より前は、値がシェルコマンドに置換されていました。

表現は、オプションを参照したサーフェスによって異なります。シェル形式フックは以下のように報告します：

```text theme={null}
Hook from plugin formatter@acme-tools references ${user_config.*} in a shell-form command. The substituted value would be re-parsed by the shell. Use exec form instead — {"command": "<executable>", "args": ["${user_config.KEY}", ...]} — or read $CLAUDE_PLUGIN_OPTION_<KEY> from the hook's environment. Command: ./scripts/notify.sh ${user_config.webhook_url}
```

モニターは以下のように報告します：

```text theme={null}
Monitor "deploy-status" from plugin deploy-tools references ${user_config.*} in its command. The substituted value would be passed to a shell. Monitor commands cannot safely reference ${user_config.*}; have the monitor script read the value from a config file or prompt instead.
```

MCP `headersHelper` は以下のように報告します：

```text theme={null}
headersHelper for MCP server 'internal-api' references ${user_config.*}. The substituted value would be passed to a shell; read the value inside the helper script instead (e.g. from an env var set in the server's "env" block).
```

**対処方法：**

* フックの場合は、`args` 配列を追加して [exec 形式](/docs/ja/hooks#exec-form-and-shell-form)で実行し、各 `${user_config.KEY}` が間にシェルなしで 1 つの引数になるようにします。または参照を削除し、スクリプト内から `$CLAUDE_PLUGIN_OPTION_<KEY>` 環境変数を読み込みます
* モニターの場合は、参照を削除し、モニタースクリプトが設定ファイルから値を読み込むようにします
* `headersHelper` の場合は、`${user_config.KEY}` をシェル解析されないサーバーの `headers` フィールドに移動するか、ヘルパースクリプト内から値を読み込みます

<h3 id="plugin-archive-integrity-check-failed">
  プラグインアーカイブの整合性チェックが失敗した
</h3>

プラグインのマーケットプレイスエントリは、`sha256` ピン付きの [`archive` ソース](/docs/ja/plugin-marketplaces#zip-archives)を使用しており、ダウンロードされたファイルのダイジェストがピンと一致しません。Claude Code はインストールを拒否するため、プラグインキャッシュに何も変更されません。不一致には 3 つの考えられる原因があります：

* 著者がピンを計算した後、URL のファイルが変更された
* 著者がマーケットプレイスエントリに間違ったダイジェストを入力した
* URL が著者がピンしたファイルとは異なるファイルを提供している

```text theme={null}
Plugin archive integrity check failed for https://artifacts.example.com/claude-plugins/my-plugin.zip: expected sha256 6bfa50e3d2e00c052b46abe51fff89346ac803e45771f76dcf6df1ab74cca5e1, got ac52220c0914ef8ca6a602e4a7362f88d30fb021110f72a6d15b68c3fe7df2b7. The archive was not installed. Verify the sha256 in the marketplace entry, or that the URL serves the intended file.
```

**対処方法：**

* プラグインを公開する場合は、URL が提供する正確なファイルのダイジェストを再計算します。例えば `shasum -a 256 my-plugin.zip` または PowerShell で `Get-FileHash -Algorithm SHA256 my-plugin.zip` を使用し、マーケットプレイスエントリの `sha256` を更新してください
* プラグインをインストールする場合は、`/plugin marketplace update <name>` を実行してカタログをリフレッシュし、エントリが修正されている場合に備えて、インストールを再試行してください
* リフレッシュ後もダイジェストが一致しない場合は、インストール前にマーケットプレイス所有者にどのファイルをピンしたかを確認してください

<h3 id="path-escapes-plugin-directory">
  パスがプラグインディレクトリをエスケープしている
</h3>

プラグインコンポーネントパス（プラグインの `plugin.json` またはその[マーケットプレイスエントリ](/docs/ja/plugin-marketplaces#plugin-entries)で宣言）が、プラグイン自体のディレクトリの外に解決されます。Claude Code はそのパスを削除し、プラグインの残りを読み込みます。メッセージ内のコンポーネント名（`commands` や `hooks` など）は、パスを宣言したフィールドに名前を付けます。

```text theme={null}
commands path escapes plugin directory: ./../shared.md
```

`claude plugin` コマンド出力では、同じエラーは `Path escapes plugin directory: ./../shared.md (commands)` と表示されます。

Claude Code は、`../shared-utils` のようにプラグインの外を指すパスと、プラグインの外につながるシンボリックリンク（[マーケットプレイスシンボリックリンクルール](/docs/ja/plugins-reference#share-files-within-a-marketplace-with-symlinks)が許可するもの以外）の両方を拒否します。シンボリックリンクの場合、メッセージはパスが解決される場所も示します：

```text theme={null}
commands path escapes plugin directory: ./commands/deploy.md — it resolves to /home/user/shared/deploy.md, outside the plugin directory
```

v2.1.251 より前は、Claude Code はマーケットプレイスエントリで宣言された `commands` パスを、プラグインディレクトリの外を指している場合でも読み込みました。Claude Code は既に `plugin.json` で宣言されたパスとマーケットプレイスエントリの他のコンポーネントパスを拒否していました。

v2.1.257 より前は、チェックはパスのスペルのみを確認し、シンボリックリンクがどこにつながるかは確認しませんでした。

**対処方法：**

* 参照されたファイルをプラグインディレクトリ内に移動し、`./` 相対パスでそれを指すようにしてください
* パスがプラグイン外のファイルへのシンボリックリンクの場合は、シンボリックリンクをファイルのコピーに置き換えてください
* 同じマーケットプレイス内の他のプラグインとファイルを共有するには、プラグインディレクトリ内のシンボリックリンクを使用してリンクし、[シンボリックリンクルール](/docs/ja/plugins-reference#share-files-within-a-marketplace-with-symlinks)に従ってください

<h3 id="failed-to-load-marketplace-configuration">
  マーケットプレイス設定の読み込みに失敗した
</h3>

Claude Code は、`~/.claude/plugins/known_marketplaces.json` のレジストリファイルに追加したプラグインマーケットプレイスを保持しています。`claude plugin install` などのレジストリが必要なプラグインコマンドは、Claude Code がファイルを使用できない場合、次の 2 つのメッセージのいずれかで失敗します：

* `Failed to load marketplace configuration`：ファイルが有効な JSON ではない、または読み込めません。空のファイルもこのように失敗します。
* `Marketplace configuration file is corrupted`：ファイルは有効な JSON ですが、その内容がレジストリスキーマと一致しません。

ファイルが見つからない場合は失敗ではありません。Claude Code はそれをマーケットプレイスなしのレジストリとして扱います。

空のファイルの場合、`claude plugin install` は以下のように報告します：

```text theme={null}
✘ Failed to install plugin "my-plugin": Failed to load marketplace configuration: JSON Parse error: Unexpected EOF
```

v2.1.246 より前は、`claude plugin install` はこの失敗を報告しませんでした。

**対処方法：**

* `~/.claude/plugins/known_marketplaces.json` を開き、JSON を修復するか、メッセージが名前を付けるエントリがレジストリスキーマと一致しないように修正してください
* 修復できない場合は、ファイルを削除するか、その内容を `{}` に置き換えてから、`claude plugin marketplace add <source>` で各マーケットプレイスを再度追加してください。Claude Code は、信頼したフォルダで次回起動するときに、ユーザーまたはマネージド設定で [`extraKnownMarketplaces`](/docs/ja/settings-reference#extraknownmarketplaces) で宣言したマーケットプレイスを再登録します。

<h2 id="tool-errors">
  ツールエラー
</h2>

これらのエラーは Claude の組み込みツールから発生します。Claude はほとんどのツールエラーを自動的に修正します。変更が必要な場合、そのエラーの **What to do** リストに何を変更するかが記載されています。

<h3 id="agent-would-be-spawned-with-zero-tools">
  Agent would be spawned with zero tools
</h3>

subagent の [`tools` リスト](/docs/ja/sub-agents#supported-frontmatter-fields)内のすべてのエントリが使用可能なツールと一致しなかったため、Claude Code は subagent の起動を拒否しました。ツールがないと、subagent は動作できません。メッセージは、エントリを何が問題かでグループ化します。

* **Unrecognized**: エントリがツール名と一致しません。通常は `Grpe` を `Grep` と誤入力するようなタイプミスです。
* **Not available to subagents**: エントリが [subagent が使用できない](/docs/ja/sub-agents#available-tools)実際のツールを指定しています。バックグラウンド subagent は、より小さい組み込みツールセットを保持しているため、フォアグラウンド subagent のみが使用できるエントリは、subagent がバックグラウンドで実行される場合（デフォルト）ここに表示されます。`Agent` をリストする場合、メッセージは代わりに次のグループの下に報告します。
* **Matched no tools in this session**: エントリは有効ですが、現在のセッション内のツールが現在それと一致しません。例えば、GitHub MCP サーバーが接続されていない `mcp__github__*` や、[深さ制限](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents)にある subagent の `Agent` などです。

`tools` フィールドを省略しても、この拒否はトリガーされません。`tools` リストを空のままにするか、`disallowedTools` がそれ内のすべてのエントリを削除する場合、Claude Code も拒否をスキップし、ツールなしで subagent を起動します。

v2.1.208 より前は、subagent はツールなしで起動され、空または混乱した結果を返す可能性がありました。

```text theme={null}
Agent 'code-reviewer' would be spawned with zero tools — refusing. Its tools list resolved to nothing: unrecognized [Grpe]. Fix the agent's tools frontmatter or pass a different subagent_type.
```

**What to do:**

* エラーが指定する各エントリを [subagent が利用可能なツール](/docs/ja/sub-agents#available-tools)に対して修正します
* セッションが持たないツール（接続されていないサーバーからの MCP ツールなど）のエントリを削除します
* [バックグラウンド subagent が削除する](/docs/ja/sub-agents#available-tools)ツール（`LSP` など）の場合、エントリを削除します。ツールを保持するには、[fork モードをオフにして](/docs/ja/sub-agents#turn-fork-mode-on-or-off)、Claude に subagent をフォアグラウンドで実行するよう依頼します
* `tools` フィールドを削除して、subagent に [subagent が利用可能なすべてのツール](/docs/ja/sub-agents#available-tools)を与えます
* `Agent` のみを含む `tools` リストの場合、[深さ制限](/docs/ja/sub-agents#let-subagents-spawn-their-own-subagents)を上げるか、エージェントに少なくとも 1 つの他のツールを与えます。Claude Code はその制限でこの深さで `Agent` を保留するため、それ以外に何もないリストは、ツールなしに解決されます

<h3 id="file-is-covered-by-a-read-deny-rule">
  File is covered by a Read deny rule
</h3>

Edit または Write ツールが [`Read` deny ルール](/docs/ja/permissions#read-and-edit)と一致するパスで呼び出されました。これには、そのパスで新しいファイルを作成することも含まれます。両方のツールは Claude が読み戻す必要があるコンテンツを変更するため、Claude Code はファイルアクセスの前に呼び出しを拒否します。NotebookEdit は `Read` deny ルールの対象ではありません。v2.1.228 より前は、ルールは Edit ツールのみをブロックし、v2.1.208 より前は、`Edit` deny ルールのみが編集をブロックしました。

```text theme={null}
File is covered by a Read deny rule in your permission settings and cannot be edited.
```

Claude Code が Write ツールを拒否する場合、メッセージは代わりに `and cannot be written` で終わります。

**What to do:**

* Claude がファイルを変更できる場合、`/permissions` または [settings](/docs/ja/settings-reference#permission-settings)の `Read` deny ルールを削除または縮小します
* ファイルが変更されないままである必要がある場合、ルールを保持し、NotebookEdit ツールもブロックするために同じパスに対して `Edit` deny ルールを追加します

<h3 id="subagent-type-is-required">
  subagent\_type is required
</h3>

```text theme={null}
subagent_type is required: the general-purpose agent is not available in this session. Available agents: ...
```

Claude は `subagent_type` なしで [Agent ツール](/docs/ja/tools-reference#agent-tool-behavior)を呼び出し、このセッションには [general-purpose subagent](/docs/ja/sub-agents#built-in-subagents)にフォールバックするものがありません。これは 2 つのセットアップの場合です。

* [`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS=1`](/docs/ja/env-vars)は非対話モードで設定されており、すべての組み込み subagent を削除します
* セッションのメインスレッドエージェントには [`tools: Agent(...)` allowlist](/docs/ja/sub-agents#restrict-which-subagents-can-be-spawned)があり、`general-purpose` を除外しています

**What to do:**

* 通常は何もしません。メッセージはセッションが持つ subagent をリストするため、Claude はそのうちの 1 つで再試行できます
* Claude が失敗し続ける場合、`tools: Agent(...)` allowlist に `general-purpose` を追加するか、`CLAUDE_AGENT_SDK_DISABLE_BUILTIN_AGENTS` を設定解除します

v2.1.235 より前は、同じ呼び出しが `Agent type 'general-purpose' not found` で失敗しました。

<h3 id="memory-index-is-over-its-read-limit">
  Memory index is over its read limit
</h3>

Claude は [auto memory](/docs/ja/memory#auto-memory)インデックス `MEMORY.md` に書き込み、その読み取り制限の 1 つを超えたままにしました。200 行または 25KB です。書き込みは成功しましたが、最初の 200 行または 25KB のみ（どちらか先に来た方）がセッションの開始時に読み込まれるため、制限を超えるすべてのものはインデックスが読み込まれるたびにドロップされます。v2.1.210 より前は、制限を超えるインデックスは次の読み込み時に警告なく静かに切り詰められました。

```text theme={null}
Error: this write left the memory index at MEMORY.md at 214 lines, over its 200-line read limit. The write succeeded, but everything past the limit is silently dropped each time the index is loaded — entries at the end are already invisible to readers. Rewrite it to under 140 lines now: keep one line per entry, move detail into topic files, and merge or drop stale entries.
```

読み込まれるコンテンツのみが制限にカウントされます。YAML frontmatter とブロックレベルの HTML コメントはインデックスが読み込まれる前に削除されるため、測定から除外されます。v2.1.211 より前は、Claude Code は生ファイルを測定し、frontmatter またはコメントは読み込まれたコンテンツが適合しても、このエラーをトリガーする可能性がありました。

Claude Code はこのエラーをターミナルのバナーとして出力するのではなく、書き込み後に Claude に配信するため、トランスクリプトでのみ気付く可能性があります。

Claude の書き込みがファイルを制限に近づけても越えない場合、Claude Code はこのエラーの代わりに、インデックスをコンパクトにするための穏やかなリマインダーを返します。

**What to do:**

* Claude に `MEMORY.md` を書き直させるか、依頼します。エントリごとに 1 行を保持し、詳細をトピックファイルに移動し、古いエントリをマージまたは削除します
* インデックスを自分で削除するには、[Audit and edit your memory](/docs/ja/memory#audit-and-edit-your-memory)を参照してください

<h3 id="pkill-pattern-matches-the-claude-code-process">
  pkill pattern matches the Claude Code process
</h3>

Bash ツール呼び出しの `pkill` コマンドは、通常 `-f` を使用するパターンを使用し、Claude Code プロセス自体と一致するため、Claude Code はコマンドを実行してセッションを終了させるのではなく、コマンドを拒否します。Claude Code は `pgrep` でパターンをテストし、独自のプロセス ID が結果に含まれている場合は拒否します。チェックは Linux でのみ実行されます。macOS では、`pkill` は変更されずに実行されます。v2.1.214 より前は、コマンドが実行され、一致するパターンが Claude Code セッションをターン中に終了させました。

```text theme={null}
pkill: refusing to run — this pattern matches the Claude CLI process (PID 12345). Narrow the pattern, or target your own children with `pkill -P $$ ...`.
```

拒否はターミナルのバナーではなく、Bash ツール結果に表示され、Claude は通常、コマンドを自動的に調整します。

**What to do:**

* パターンを絞り込んで、短い部分文字列ではなく、ターゲットバイナリの完全なパスなど、意図したプロセスのみと一致するようにします
* 現在のシェルで開始されたプロセスを停止するには、パターンで `pkill -P $$` を使用します。これにより、マッチをシェルの独自の子プロセスに制限します

<h3 id="failed-to-write-to-a-teammate-inbox">
  Failed to write to a teammate's inbox
</h3>

Claude Code は `~/.claude/teams/{team-name}/inboxes/` の下のチームメイトのメールボックスファイルにメッセージを書き込むことができなかったため、受信者は何も受け取りませんでした。書き込みは、Claude Code がファイルを作成または更新できない場合に失敗します。例えば、ディスクがいっぱい、ディレクトリが書き込み可能でない、または別のエージェントがインボックスロックを長時間保持している場合などです。v2.1.224 より前は、Claude Code は書き込みが失敗した場合でも、メッセージが送信されたと報告しました。

エラーはターミナルのバナーではなく、送信エージェントのツール結果に表示され、テキストは Claude に再試行するよう指示します。

```text theme={null}
Failed to write to researcher's inbox — nothing was sent. Try again, or message the lead.
```

構造化された [agent team](/docs/ja/agent-teams)プロトコルメッセージは同じ方法で失敗し、エラーは未配信メッセージに名前を付けます。Claude Code が計画承認、計画却下、シャットダウン要求、またはシャットダウン却下を書き込むことができない場合、エラーは `Failed to write the <message> to <name>'s inbox — nothing was sent` と読みます。そのリストの `plan approval` はチームメイトの計画を承認するリーダーの決定です。チームメイトの計画提出は、別の `plan approval request` メッセージです。そのメッセージと他の 2 つのプロトコルメッセージは、独自のメッセージテキストと結果を持ちます。

* `Failed to write the plan approval request to the lead's inbox — plan not submitted; try again`: チームメイトの計画がリーダーに到達せず、チームメイトは再提出が成功するまで計画モードのままです
* `The permission request could not be delivered to the team lead (mailbox write failed)`: チームメイトの権限要求がリーダーに到達しなかったため、誰もツール呼び出しを承認しませんでした
* `The confirmation could not be written to team-lead's inbox.`: シャットダウン承認自体が有効になり、チームメイトが終了します。リーダーへの確認のみが不足しています

リード セッションでチームメイト自身にメッセージを送信する場合、`@name` に続いてメッセージを入力すると、同じ失敗は通知として表示されます。`Couldn't write to @name's inbox — message not sent. Try again.` であり、Claude Code はテキストをプロンプトボックスに保持して、再度送信できるようにします。

**What to do:**

* 送信者にメッセージを再送信するよう依頼します。インボックスロックの競合は一時的であり、再試行時にクリアされます
* 空きディスク容量を確認し、`~/.claude/teams` とその下のファイルがユーザーによって書き込み可能であることを確認します

<h3 id="message-too-large-for-cross-session-delivery">
  Message too large for cross-session delivery
</h3>

Claude の [cross-session message](/docs/ja/cross-session-messaging)は、このマシン上の別のセッションに対して長すぎて送信できませんでした。Claude Code はそれを拒否し、受信セッションは何も受け取りませんでした。拒否は、ターミナルのバナーではなく、送信セッションのツール結果に表示されます。両方のサイズとメッセージを適合させる方法に名前を付けます。

```text wrap theme={null}
Failed to send to api-worker: Message too large for cross-session delivery: the serialized message is 1,203,844 characters and the limit is 1,048,576. Shorten the message text — put bulk content in a file the recipient can read rather than in the message — or split it into smaller messages.
```

同じテキストを再送信すると、同じ方法で失敗します。

**What to do:**

* Claude にメッセージを要約するか、バルクコンテンツをファイルに入れて、受信者が読むことができるようにするよう依頼します
* Claude にコンテンツを複数の短いメッセージに分割するよう依頼します

v2.1.235 より前は、Claude Code は超過サイズのメッセージを送信されたと報告しました。受信セッションはそれを未読でドロップしました。

<h3 id="too-many-messages-to-this-session-just-now">
  Too many messages to this session just now
</h3>

Claude は、このマシン上の 1 つのセッションに対して [cross-session messages](/docs/ja/cross-session-messaging)の急速なバーストを送信し、バーストはそのセッションのインボックスが受け入れるものに達しました。Claude Code は次の送信を拒否し、受信セッションはそれから何も受け取りませんでした。拒否は、ターミナルのバナーではなく、送信セッションのツール結果に表示されます。

```text wrap theme={null}
Failed to send to api-worker: Too many messages to this session just now: 30 were sent recently and more would be dropped by its rate limit, so this one was not sent. Batch what remains into one message, or wait a little before sending more.
```

**What to do:**

* 通常は何もしません。Claude は残りのコンテンツを 1 つのメッセージにバッチするか、さらに送信する前に少し待ちます
* バースト自体をプロンプトした場合、Claude に残りのものを 1 つのメッセージに結合するよう依頼します

v2.1.236 より前は、Claude Code はこれらの送信を送信されたと報告しました。受信セッションはそれらを未読でドロップしました。

<h3 id="refusing-to-send-a-cross-session-message">
  Refusing to send a cross-session message
</h3>

Claude Code が [cross-session message](/docs/ja/cross-session-messaging)をこのマシン上の別のセッションに書き込む前に、ターゲットセッションのインボックスソケットがメッセージが宛てられたエンドポイントであることを確認します。チェックが失敗すると、Claude Code は送信セッションで送信を拒否し、ターゲットセッションは何も受け取りません。Claude が送信するメッセージの場合、拒否は送信セッションのツール結果に表示されます。

```text theme={null}
Failed to send to api-worker: Refusing to send: reply target is a symlink
```

`Refusing to send:` の後のテキストは、失敗したチェックに名前を付けます。

* `reply target is a symlink`: シンボリックリンクがターゲットセッションのソケットパスにあります。Claude Code はそれを通じて配信しません。リンクがそこにあると、メッセージをターゲットセッションが作成しなかったエンドポイントにリダイレクトする可能性があるためです。
* `cannot vet reply target`: Claude Code はターゲットパスをまったく検査できませんでした。例えば、権限エラーで読み取りが失敗した場合などです。
* `connected endpoint is not the expected process`: ソケットを保持しているプロセスは、メッセージが宛てられたセッションではないため、アドレスは古いか、別のプロセスがソケットを置き換えました。
* `connected endpoint identity could not be read`: Claude Code は接続しましたが、どのプロセスが反対側を保持しているかを読み取ることができなかったため、ターゲットを確認できませんでした。これは一時的である可能性があります。
* `connected endpoint is not owned by this user`: ソケットを保持しているプロセスは別のユーザーアカウントで実行されるため、セッションの 1 つではありません。
* `connected endpoint owner could not be read`: Claude Code は接続しましたが、どのユーザーアカウントが反対側を所有しているかを読み取ることができなかったため、エンドポイントがあなたのものであることを確認できませんでした。
* `connected endpoint is a different process with the expected pid`: プロセス ID はメッセージが宛てられたものと一致しますが、Claude Code はそれが同じプロセスであることを確認できませんでした。通常、そのセッションが終了し、オペレーティングシステムがプロセス ID を再利用したため、アドレスは古いです。

**What to do:**

* 通常は何もしません。チェックはメッセージが宛てられたセッション以外のエンドポイントに到達するのを防ぎ、何も送信されませんでした
* Claude にセッションを再度リストするよう依頼して再送信します。古いアドレスが原因の拒否は、Claude が現在のセッションに送信すると消えます
* `reply target is a symlink` が 1 つのセッションで繰り返される場合、そのセッションのソケットパスにリンクを作成したものを確認します。これは `/status` の `Peer address` に表示されます
* `connected endpoint identity could not be read` の場合、再送信します。条件は一時的である可能性があります
* `connected endpoint is not owned by this user` が共有マシンに表示される場合、そのアドレスのセッションは別のユーザーのアカウントで実行されるため、Claude はあなたのアカウントからそれにメッセージを送信できません

v2.1.248 より前は、Claude Code はエンドポイントの所有ユーザーまたはプロセス開始時刻をチェックしなかったため、これらのチェックに名前を付ける拒否は以前のバージョンに表示されません。

<h3 id="refusing-after-a-symlink-changed">
  Refusing to read, write, or search a path
</h3>

Claude Code はファイルパスの [permission rules](/docs/ja/permissions#read-and-edit)をチェックし、ツールがファイルを開くか検索を開始するときに解決を再度確認します。パスがチェックが承認した場所にまだ導いていることを確認できない場合、Claude Code はそれに従う代わりに操作を拒否します。拒否はツール結果に表示されます。

```text theme={null}
Refusing to read /path/to/file: its symlink resolution changed after permission was checked. If a link in the working directory is being rewritten concurrently, stop that and retry.
```

パスの後のテキストは理由に名前を付けます。

* `its symlink resolution changed after permission was checked`: パスに沿ったシンボリックリンク、または Grep または Glob 検索ルートが、権限チェックと操作の間に置き換えられました
* `its parent-directory symlink resolution changed after permission was checked`: 書き込みパスが通過するディレクトリは、承認された場所にもはや解決されません
* `it is a symbolic link. Write to the link's target path instead`: シンボリックリンクが承認された書き込み場所自体にあります
* `a path one of its Read deny rules is written through changed while the search was being prepared. Retry.`: `Read` deny ルールの検索がシンボリックリンクを通過するパスに名前を付け、そのリンクが Claude Code が検索を準備している間に変更されました
* `it could not be opened (EACCES) — it is unreadable, or is being replaced concurrently.`: 検索ルートは存在しますが、開くことができませんでした。括弧内のコードはオペレーティングシステムエラーです
* `its permission check expired before it ran (too many concurrent file operations). Retry.`: Claude Code は多くの同時ファイル操作の下で、ツールが使用する前に承認レコードを削除しました。再試行は新しい権限チェックを実行します
* `ripgrep was found only by name on PATH, and a search outside the working directory cannot apply your Read deny rules in that configuration`: Claude Code は `rg` バイナリを絶対パスに解決できなかったため、deny ルールをカバーしない検索を実行するのではなく、作業ディレクトリの外の検索を拒否します

**What to do:**

* 通常は何もしません。拒否は Claude にツール結果として到達し、拒否された操作は実行されません
* シンボリックリンク拒否が 1 つのパスで繰り返される場合、ビルドツールやファイルウォッチャーなど、リンクをそこで書き直し続けるものを見つけるか、Claude にリンクされたものの代わりにファイルの解決されたパスを使用するよう依頼します
* ripgrep 拒否の場合、パッケージマネージャーで ripgrep をインストールして、`rg` が `PATH` 上の絶対パスに解決されるようにするか、作業ディレクトリの下で検索を保持します

v2.1.251 より前は、Claude Code はファイル書き込みに対してのみパスの解決を再チェックしたため、権限チェック後に置き換えられたリンクは、メッセージなしで読み取りまたは検索を別の場所にリダイレクトする可能性がありました。これらの拒否のうち、親ディレクトリ書き込み拒否のみが以前のバージョンに表示されます。

<h3 id="task-output-swap-refused">
  Task output swap refused
</h3>

Claude Code は各 Bash コマンドの出力をその一時ディレクトリの下のファイルに保存します。このメッセージは、そのファイルのパス上のディレクトリがシンボリックリンクであるか移動されたことを意味するため、Claude Code はそのパスを通じて出力を書き込むのではなく、コマンドの実行を拒否しました。メッセージは Bash ツール結果に表示されます。

```text wrap theme={null}
task output swap refused (tasks dir moved or linked): /private/tmp/claude-501/-Users-you-my-project/1f0e62dc-4b0a-4f5e-9c2d-8a7b6c5d4e3f/tasks/b7k2f9m3q.output. To recover: restart Claude Code with CLAUDE_CODE_TMPDIR set to a fresh directory; or, if /private/tmp/claude-501/-Users-you-my-project is a stray directory or a symbolic link that should not be there, remove that entry itself (not what it points to) and restart.
```

**What to do:**

* v2.1.260 以降にアップグレードします。以前のバージョンは、リンクまたは移動されたディレクトリが存在しない場合でも、このメッセージを表示することがあります
* [`CLAUDE_CODE_TMPDIR`](/docs/ja/env-vars)を新しいディレクトリに設定して Claude Code を再起動します
* または、プロジェクトのディレクトリを Claude Code 一時ディレクトリの下で確認します。例のメッセージでは `/private/tmp/claude-501/-Users-you-my-project` です。そのパスがシンボリックリンクであるか、そこにあるべきではないディレクトリである場合、リンクのターゲットではなく、リンクまたはディレクトリ自体を削除して、Claude Code を再起動します

<h2 id="background-session-errors">
  バックグラウンドセッションエラー
</h2>

[バックグラウンドセッション](/docs/ja/agent-view)は独自のインタラクティブターミナルなしで実行されるため、ターミナルが必要なコマンドはそこで異なる動作をします。これらのメッセージはバックグラウンドセッションのトランスクリプト、それに接続するターミナル、ディスパッチ元のセッションまたはシェル、または以下の[worktree-guard エントリ](#write-or-command-blocked-because-the-path-cannot-be-safely-resolved)の場合は worktree に分離されたセッションまたは worktree 分離サブエージェントを実行しているセッションに表示されます。メッセージが特定の表面に固有の場合、そのエントリに記載されています。

<h3 id="commands-refused-in-a-background-session">
  バックグラウンドセッションで拒否されたコマンド
</h3>

インタラクティブダイアログを開くコマンドは、バックグラウンドセッションにターミナルが接続されていない間は実行できません。`/install-github-app`、`/mcp` 設定リスト、および MCP サーバーメニューの認証アクションは、メッセージで応答し、セッションは[エージェントビュー](/docs/ja/agent-view)の**入力が必要**に表示されるため、セッションを見つけて接続し、コマンドを再度実行できます。ターミナルが接続されている間、これらのコマンドは正常に機能します。

v2.1.216 より前では、これらの拒否の後、セッションは**入力が必要**に表示されませんでした。v2.1.213 から v2.1.215 では、ターミナルが接続されている間、コマンドは引き続き機能し、拒否メッセージは接続して再度コマンドを実行するよう指示していました。v2.1.208 から v2.1.212 では、Claude Code はターミナルが接続されている間でもこれらを拒否し、`Can't open MCP settings in a background session` などのメッセージが表示されていました。これらのバージョンでは、通常の `claude` セッションからコマンドを実行するか、アップグレードしてください。v2.1.208 より前では、バックグラウンドセッション内でダイアログが開きました。v2.1.208 のみで、Claude Code はバックグラウンドセッションの `/model` ピッカーも拒否し、`/upgrade` はブラウザを開く代わりにアップグレード URL を出力しました。

表現はコマンドに名前を付けます。`/mcp` 設定リストは以下を報告します：

```text theme={null}
Can't open MCP settings while no terminal is attached to this background session. This session now shows "needs input" in agent view — open it and run /mcp to manage servers, or use `/mcp enable|disable|reconnect <server>` to steer without the panel.
```

**対処方法：**

* エージェントビューからセッションに接続します。セッションは**入力が必要**に表示されており、コマンドを再度実行します
* または、メッセージが名前を付けた形式を使用します。例えば `/mcp reconnect <server>`、`/mcp enable`、または `/mcp disable` は、接続せずに機能します

<h3 id="write-or-command-blocked-because-the-path-cannot-be-safely-resolved">
  パスを安全に解決できないため、書き込みまたはコマンドがブロックされました
</h3>

Claude は、[worktree 分離ガード](/docs/ja/agent-view#how-file-edits-are-isolated)が 1 つの検証可能な場所に解決できないスペルを通じてファイルまたは作業ディレクトリにアクセスしました。ガードは、[worktree に分離されたセッション](/docs/ja/worktrees#how-claude-code-enforces-isolation)（インタラクティブまたはバックグラウンド）および[worktree 分離サブエージェント](/docs/ja/worktrees#isolate-subagents-with-worktrees)での書き込みとコマンド作業ディレクトリをチェックします。解決前にシンボリックリンクを解決し、操作が共有チェックアウトに到達しないことを確認します。解決に失敗すると、操作をブロックして、そこに到達させません。メッセージは、拒否するパス形式と再試行方法に名前を付けます：

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
* ファイルがローカルファイルのスペルが付いたネットワークパスではなく、ネットワーク共有上にある場合、セッションのローカルワークスペースの外にあります。通常のインタラクティブセッションから編集してください

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
* **`already open in another running Claude session`**：別の非インタラクティブ Claude Code プロセスがそれを保持しています。例えば、同じ会話の[バックグラウンドセッション](/docs/ja/agent-view#the-supervisor-process)プロセスがまだ終了していません。

Claude Code は、行を開くときに入力した返信を保存し、セッションが次に開始するときにセッションの次のプロンプトとして送信します。

**対処方法：**

* 会話を開いているプロセスで会話を続けるか、そのプロセスを終了して行を再度開きます

v2.1.248 より前では、`already open in another running Claude session` 拒否のみが存在していました：ターミナルで再開された会話は開いているとはカウントされず、行を開くと同じ会話に書き込む 2 番目の Claude Code プロセスが開始されました。

<h3 id="this-sessions-saved-conversation-is-no-longer-on-disk">
  このセッションの保存された会話はディスク上にもうありません
</h3>

[バックグラウンドセッション](/docs/ja/agent-view)を開きました。このセッションはバックグラウンドサービスがオフの間に終了し、[トランスクリプトクリーンアップ](/docs/ja/settings-reference#cleanupperioddays)がその保存された会話を削除しました。例えば、マシンが数週間オフになった後です。通常、そのような行を開くと、[保存された会話を再開](/docs/ja/agent-view#sessions-show-as-failed-after-shutdown)します。再開するものがないため、Claude Code は、セッションの元のプロンプトを再実行するよう求めずに拒否します：

```text theme={null}
This session's saved conversation is no longer on disk (it ended while the background service was off, and old transcripts are cleaned up), so there is nothing to resume. `claude rm 7c5dcf5d` deletes the row; `claude respawn 7c5dcf5d` runs its original prompt again instead.
```

`claude attach <id>` はこのテキストを出力します。エージェントビューでは、フッターはより短く、`ctrl+x deletes the row` で終わります。

**対処方法：**

* `claude rm <id>` を実行して行を削除します。[保持されたケース](/docs/ja/agent-view#what-deleting-a-session-removes)の 1 つが適用される場合、`claude rm` は行と worktree を保持し、理由に名前を付けます
* セッションの元のプロンプトを新しい会話として再度実行するには、`claude respawn <id>` を実行します

v2.1.248 より前では、そのような行を開くと、セッションの元のプロンプトを再実行し、数週間前のタスクをフォアグラウンドに引き戻しました。

<h3 id="worktree-has-commits-that-are-not-pushed-anywhere">
  Worktree にはどこにもプッシュされていないコミットがあります
</h3>

[バックグラウンドセッション](/docs/ja/agent-view#what-deleting-a-session-removes)を削除しようとしました。その worktree は、Claude Code が他の場所に保存されていることを確認できないコミットを保持しています。Claude Code は、コミットを見ずに破棄するのではなく、worktree とセッション行を保持します。`claude rm` はブランチとプッシュされていないコミットに名前を付け、進め方を説明します：

```text theme={null}
kept 7c5dcf5d — 2 unpushed commits on claude/fix-login (a1b2c3d Fix login flow, … and 1 more)
  worktree: /home/you/project/.claude/worktrees/fix-login
  push them, or discard the worktree and its commits: claude rm 7c5dcf5d --discard-unpushed a1b2c3d000000000000000000000000000000000@0123456789abcdef0123456789abcdef
```

Claude Code がコミットを要約できない場合、メッセージは代わりに `worktree has commits that are not pushed anywhere` を読みます。[エージェントビュー](/docs/ja/agent-view)では、セッションの行は同じ理由で `not deleted` を表示します。

リモート上のコミットは削除をブロックしません。ローカルコピーの `origin` リモートのデフォルトブランチ上のコミットもブロックしません。そのブランチがメインチェックアウト（リポジトリディレクトリ自体、worktree ではなく）でチェックアウトされている限り。

**対処方法：**

* コミットを保持するには、worktree のブランチをプッシュするか、メインチェックアウトでチェックアウトされたデフォルトブランチにマージしてから、セッションを再度削除します
* コミットを破棄するには、メッセージが出力した `claude rm <id> --discard-unpushed` コマンドを実行するか、エージェントビューのセッション行で `Ctrl+X` を 2 回押します。これにより、セッション、worktree、そのブランチ、プッシュされていないコミット、およびコミットされていない変更が削除されます。worktree が拒否以降にコミットを獲得した場合、Claude Code はそれを再度保持し、更新された状態を表示します
* メッセージが worktree が別の完了したセッションによっても記録されていることを示す場合、再度削除してもそれは破棄されません：コミットをプッシュしてから、セッションを再度削除します

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

チェックが実行される前に行を開くと、フッターは `This session's terminal host process died (the conversation is saved) — press Enter to restart it` を表示し、行は失敗になります。

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

[カスタムエージェント](/docs/ja/sub-agents#invoke-subagents-explicitly)を実行していたセッションを再開しました。`--agent` またはエージェント設定で開始され、Claude Code はその名前のエージェントを見つけませんでした。セッションの元のディレクトリを最初に検索します。[そのワークスペースを信頼](/docs/ja/permissions#project-allow-rules-and-workspace-trust)している場合、再開するディレクトリを検索します。セッションは引き続き再開されますが、デフォルトツールとシステムプロンプトを使用するため、エージェントのツール制限は適用されなくなります：

```text theme={null}
This session was running agent 'code-reviewer', which is no longer available (no agent by that name in /home/you/project). Continuing with the default tools and system prompt — the agent's tool restrictions no longer apply. To restore it, re-create the agent, or resume with an explicit --agent <name>.
```

警告は、Claude Code が検索したディレクトリのみに名前を付け、[バックグラウンドセッション](/docs/ja/agent-view)を起動するか、`/resume` または `claude --resume` を実行するか、[非インタラクティブモード](/docs/ja/headless)で再開するかどうかに関わらず、再開された会話に表示されます。そこでは stderr にも送信されます。`--input-format stream-json` を使用するセッションは、Agent SDK がスタートアップ後にエージェントを提供するため、表示されません。

Claude Code はセッションへのフォールバックを保存しないため、警告は、対処するまで各再開で繰り返されます。組み込みの `claude` エージェントは、デフォルトツールセットへのフォールバックがそれに対して何も変わらないため、警告をトリガーしません。v2.1.216 より前では、Claude Code は静かにデフォルトエージェントとして続行し、ルックアップは再開するディレクトリのみをカバーしていたため、プロジェクトスコープのエージェントは別のディレクトリから再開すると失われました。

**対処方法：**

* セッションのプロジェクトの `.claude/agents/<name>.md` または個人エージェントの `~/.claude/agents/<name>.md` にエージェントファイルを再作成してから、再度再開します
* または、`--agent <name>` で再開して、存在するエージェントに名前を付けて、セッションをそのエージェントとして実行します
* エージェントがプロジェクトスコープで、セッションの元のディレクトリを信頼していない場合、そこで Claude Code を 1 回実行し、信頼ダイアログを受け入れてから、再度再開します

<h3 id="claude_code_process_wrapper-launcher-errors">
  CLAUDE\_CODE\_PROCESS\_WRAPPER ランチャーエラー
</h3>

[`CLAUDE_CODE_PROCESS_WRAPPER`](/docs/ja/corporate-launcher)が設定されており、その値は使用できないため、Claude Code はランチャーなしで実行するのではなく、影響を受けるプロセスの開始を拒否します。構成の問題は、変数名で始まり、理由を述べるメッセージで報告されます。例えば：

```text theme={null}
CLAUDE_CODE_PROCESS_WRAPPER: launcher `/opt/corp/launcher` is not an executable regular file
```

開始するが Claude Code で自分自身を置き換えずに終了するランチャーは、それが開始していたセッションを失敗させ、エージェントビューのセッション行は、ランチャーが `must exec, not daemonize` に続いて、ランチャーが出力したものを報告します。バックグラウンドサービスに到達できないセッションは、ランチャーの問題を理由として `Couldn't reach the background service (...)` 内で報告します。

**対処方法：**

* 変数を、`exec "$@"` を呼び出して終了する実行可能ファイルの絶対パスに設定します。完全な契約については、[ランチャー契約](/docs/ja/corporate-launcher#the-launcher-contract)を参照してください
* `/status` をチェックします。これは Self-exec エントリで解決されたランチャーコマンドを表示し、実行中のバックグラウンドサービスが一致しない場合に警告するか、シェルから `claude daemon status` を実行します
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

Claude Code は PowerShell を通じてバックグラウンドサービスを開始するため、ターミナルを閉じてもサービスが存続します。PowerShell 7 がインストールされている場合はそれを使用し、そうでない場合は Windows PowerShell 5.1 を使用します。どちらの PowerShell も実行できない場合、Claude Code は代わりにサービスを直接開始するため、PowerShell のみをブロックするポリシーはこのエラーを引き起こしません。npm インストールが実行されていない間にそれを見る場合、ポリシーは Claude Code 実行可能ファイル自体をブロックしています。

v2.1.212 より前では、Claude Code は Windows PowerShell 5.1 のみを使用してサービスを開始していたため、グループポリシーが PowerShell 5.1 をブロックしたマシンは、PowerShell 7 がインストールされていても `Couldn't start the session — EUNKNOWN: unknown error, uv_spawn` で失敗しました。

**対処方法：**

* メッセージが `Couldn't start the session` を読む場合、v2.1.212 以降にアップグレードします。以前のバージョンでは、別のターミナルで最初に `claude daemon run` を実行してから、バックグラウンドセッションを再度開始することもできます。そのコマンドはバックグラウンドサービスをターミナルのフォアグラウンドで実行するため、サービスはそのターミナルが開いている限り続きます。
* npm インストールがバイナリを置き換えていた場合、完了するまで待ってから、バックグラウンドセッションを再度開始します
* エラーが npm インストールが実行されていない間に v2.1.212 以降で表示される場合、Windows 管理者に Claude Code 実行可能ファイルを制限ポリシーで許可するよう依頼します
* ターミナルを閉じるとバックグラウンドサービスが停止する場合、Claude Code は PowerShell なしでそれを開始しました。PowerShell 7 をインストールするか、管理者に PowerShell をブロック解除するよう依頼して、サービスがターミナルより長く続くようにします。

<h3 id="eacces-when-starting-a-background-session">
  バックグラウンドセッションを開始するときの EACCES
</h3>

Claude Code は、[バックグラウンドセッション](/docs/ja/agent-view#the-supervisor-process)をホストするバックグラウンドサービスを開始するために、独自のバイナリを実行できませんでした。npm インストールでは、これは通常、`npm install -g @anthropic-ai/claude-code` がその時点でバイナリを置き換えていることを意味します。実行したか、[自動アップデーター](/docs/ja/setup#auto-updates)が実行したかどうか。エラーは、[エージェントビュー](/docs/ja/agent-view)からセッションを開くときに表示されます：

```text theme={null}
Couldn't start the background service — spawn background service: EACCES: permission denied, posix_spawn '/usr/local/lib/node_modules/@anthropic-ai/claude-code/bin/claude'
```

`/background` または `claude --bg` でセッションを開始する場合、同じ理由は `Couldn't reach the background service (...)` 内に表示されます。同じ再インストールウィンドウ中に、エラーは `ENOENT` または `ENOEXEC` などの別のコードに名前を付けることができます。または Windows では `EUNKNOWN` または `EPERM`。再試行全体で持続する `EUNKNOWN` は[異なる原因](#eunknown-when-starting-a-background-session)を持っています。

npm インストールでは、Claude Code は再インストールが完了するのを待ち、独自に再試行します：最大 10 秒、および Claude Code の npm インストールがマシン上で明らかにまだ実行されている間、最大 2 分。これは別の Claude Code プロセスがアップデートをダウンロードしている場合をカバーします。インストールがその待機を超える場合、失敗は裸のエラーコードではなくアップデートに名前を付けます：

```text theme={null}
Claude Code is being updated by npm on this machine (still not runnable after 2 min, EACCES) — try again when the update finishes
```

v2.1.257 より前では、待機は 10 秒で停止していたため、別の Claude Code プロセスがまだアップデートをダウンロードしている間にこのエラーが表示されました。v2.1.246 より前では、Claude Code は待機なしで直ちに失敗しました。

**対処方法：**

* 数秒待ってから、セッションを開くか再度ディスパッチします。メッセージが Claude Code が更新されていることを示す場合、アップデートが完了した後に再試行します。
* npm インストールが実行されていない間にエラーが持続する場合、ユーザーはインストールされたバイナリを実行できません。そのパーミッションとそのディレクトリのパーミッションをチェックするか、Claude Code を再インストールします。

<h3 id="background-service-exited-before-it-became-reachable">
  バックグラウンドサービスが到達可能になる前に終了しました
</h3>

Claude Code が[バックグラウンドサービス](/docs/ja/agent-view#the-supervisor-process)として開始したプロセスは、接続を受け入れる前に終了したため、Claude Code はセッションを開くことができませんでした。サービスが終了する前にエラーを出力した場合、括弧内の理由は終了コードまたはシグナルと、サービスが出力した最初の行を示します。これはそれを停止したものに名前を付けます：

```text theme={null}
Couldn't reach the background service (background service exited before it became reachable (exit code N): <the service's first error line>) — run 'claude daemon status'
```

[エージェントビュー](/docs/ja/agent-view)からセッションを開く場合、同じ理由は `Couldn't start the background service —` に従います。サービスが終了する前に何も出力しなかった場合、メッセージは代わりに `nothing on stderr` を示しています。

Claude Code はサービスのエラー行で失敗を報告します。v2.1.246 より前では、失敗は 45 秒の待機後にのみ表示され、`background service did not become reachable within 45s` として、サービスのエラー行なしで表示されました。

2 つの引用された理由は既知の原因を持っています：

* `Error: claude native binary not installed.`：npm インストールがその時点で Claude Code バイナリを置き換えていたため、サービスは npm のプレースホルダーを実行しました。インストール完了後に再試行します。インストールが実行されていない間に行が持続する場合、[npm インストールを完了](/docs/ja/troubleshoot-install#native-binary-not-found-after-npm-install)します。v2.1.257 より前では、macOS npm 自己更新はインストールウィンドウ中のすべての開始でこの失敗を生成しました。
* Windows で、すべての開始で終了コード 1 で `nothing on stderr`：`daemon.lock` は、Claude Code がシグナルを送信することも、消えたことを証明することもできないプロセスに名前を付けます。そのため、各新しいサービスは別のサービスがロックを保持していると結論付け、終了します。Claude Code が消えたことを証明できるロックは、独自に置き換えられ、この失敗を生成しません。失敗がすべての開始で繰り返される場合、`~/.claude/daemon.lock` を削除してから、セッションを開くか再度ディスパッチします。v2.1.257 より前では、そのようなロックはファイルを削除するまですべての開始をブロックしました。

**対処方法：**

* メッセージが行を引用する場合、それが名前を付けるものを修正してから、セッションを開くか再度ディスパッチします。次の試行はサービスを再度開始します
* `claude daemon status` を実行して、サービスが現在実行されているかどうかをチェックします

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
* リンクを作成していない場合は、その内容を信頼する前にパスを検査してください。チェックポイント後にファイルが置き換わった可能性があります。

<h3 id="no-files-were-restored">
  No files were restored
</h3>

Claude Code は、[`/rewind`](/docs/ja/checkpointing) でコードを復元しようとしたときにそのチェックポイント内のファイルを復元できない場合、このメッセージを表示します。各ファイルについて、Claude Code が編集前に保存したバックアップが見つからないか、Claude Code がファイルに書き込みまたは削除できませんでした。

```text theme={null}
Failed to restore the code:
No files were restored: 1 file failed (backup missing, or the file could not be updated)
```

Claude Code は、[retention sweep](/docs/ja/claude-directory#cleaned-up-automatically) でセッションのバックアップを削除します。デフォルトではセッションが最後にバックアップを保存してから約 30 日後です。その後にセッションを再開した場合、`/rewind` はそのチェックポイントをリストしますが、そのいずれかに rewind すると、このエラーで失敗する可能性があります。メッセージに `N paths were skipped for link safety` も表示されている場合は、これらのパスについて [Restored the code, but skipped files](#restored-the-code-but-skipped-files) を参照してください。

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

<h3 id="fullscreen-failed-start-notice">
  フルスクリーンレンダラーが起動を完了しませんでした
</h3>

このマシン上の以前の [フルスクリーン](/docs/ja/fullscreen) セッションが起動を完了する前に終了したため、Claude Code はこのセッションをクラシックレンダラーで起動し、次のいずれかの通知を出力します。

```text theme={null}
Claude Code's fullscreen renderer didn't finish starting last time on this machine, so this launch is using the classic renderer. It will try fullscreen again next launch; /tui default keeps the classic renderer.

Claude Code's fullscreen renderer has repeatedly failed to start on this machine, so it has been turned off here. Run /tui fullscreen to try it again (this also resets after an update).
```

**対応方法：**

* [フルスクリーンレンダリング](/docs/ja/fullscreen#fullscreen-renderer-didnt-finish-starting) に従ってください。どの通知が表示されるか、Claude Code が後続のセッションで何を行うか、およびフルスクリーンを再度試すか、クラシックレンダラーを保持する方法が説明されています。
* 終了したセッションが終了メッセージを出力した場合は、[Claude Code が回復不可能なインターフェイスエラーの後に終了しました](#exited-after-an-unrecoverable-interface-error) を参照して、その名前を確認してください。

v2.1.236 より前では、Claude Code は通知を出力せず、失敗した起動後もフルスクリーンレンダリングでセッションを起動し続けていました。

<h3 id="exited-after-an-unrecoverable-interface-error">
  Claude Code が回復不可能なインターフェイスエラーの後に終了しました
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

セッションは [サーバー管理設定](/docs/ja/server-managed-settings) の対象ですが、Claude Code はそれらを取得できなかったため、対話型セッションでこの警告を表示します。括弧内の原因は、`network error`、`request timed out`、または `authentication rejected (401)` などの失敗した内容に名前を付け、行の残りはセッションが実行するポリシーを示します。

* **以前の成功した取得からキャッシュされた設定**：Claude Code は [保留されている環境変数](/docs/ja/server-managed-settings#fetch-and-caching-behavior) を除いて、そのキャッシュされたポリシーでセッションを実行し、行は `using cached policy` と読みます。
* **キャッシュなし**：Claude Code はサーバー管理設定なしでセッションを実行し、行は `no remote policy applied` と読みます。

**対応方法：**

* メッセージが名前を付ける原因に対応してください。ネットワーク原因の場合は、このマシンが `api.anthropic.com` に到達できることを確認してください。認証原因の場合は、`/status` で サインインを確認してください。
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

[Claude Code がドロップした エントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、各ソースを解析不可能にするものをリストしています。

Claude Code は、別の管理ソースが有効なポリシーを配信する場合でも、起動を拒否します。この エラーは対話型セッション、`claude -p`、Agent SDK セッション、[バックグラウンドセッション](/docs/ja/agent-view)、およびほとんどのサブコマンド（`claude doctor` を含む）で表示されます。拒否は意図的に閉じられます。Claude Code が解析できないドキュメント内の設定は強制できず、とにかく起動すると、組織の制御なしでセッションが実行されます。

解析可能なドキュメント内のスキーマ問題はこのエラーを生成しません。[Claude Code がドロップしたエントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、Claude Code が 1 つで何を行うかをカバーしています。

`managed-settings.d/` ディレクトリが存在しますが、リストできない場合、Claude Code は `Managed settings drop-in directory could not be read:` の後に基になるエラーを報告します。[Claude Code がドロップしたエントリを検索](/docs/ja/managed-settings#find-entries-claude-code-dropped) は、読み取り失敗がスタートアップで終了する場合をカバーしています。

**対応方法：**

* マシンを管理している場合は、名前が付けられたドキュメントを JSON オブジェクトとして解析するように修正するか、ファイル、プロファイル、またはレジストリ値を削除してください。空の `managed-settings.json` は `{}` としてカウントされ、起動をブロックしません。
* そうでない場合は、管理者に、デプロイされたドキュメントを修正するよう依頼してください。独自の設定ファイルの何もこのエラーを引き起こしたり、クリアしたりしません。

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
* コンテンツ内の括弧はそのままにしてください。それらはリテラルなので、`Edit(./Finance (2024)/**)` などのルールは エスケープなしで有効です。

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

Claude Code は同じ形状の deny および ask ルールについて警告しません。それらが一致する追加コマンドを拒否またはプロンプトします。また、サブコマンドが最初の `*` の前に来るルール（`Bash(git commit *)` など）、または `*` の後に オプション以外の単語がないルール（`Bash(git *)` など）、または `:*` プレフィックスルール（`Bash(git:*)` など）についても警告しません。

[バックグラウンドセッション](/docs/ja/agent-view) または `--output-format json` または `stream-json` では、Claude Code は警告をデバッグログに stderr の代わりに書き込むため、マシン読み取り出力はクリーンなままです。`--debug` で `~/.claude/debug/<session-id>.txt` でキャプチャしてください。v2.1.246 より前では、Claude Code はこれらのルールを警告なしで受け入れていました。

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

<h2 id="responses-seem-lower-quality-than-usual">
  応答の品質がいつもより低いように見える
</h2>

Claude の回答がいつもより能力が低いように見えるが、エラーが表示されていない場合、原因は通常、モデル自体ではなく会話の状態です。Claude Code はモデルバージョンを静かに変更することはありません。3 つの特定のケースでフォールバックモデルに切り替わることができます。

* 設定された [`--fallback-model`](/docs/ja/cli-reference#cli-flags) は可用性エラーの後、そのターンのみ引き継ぎ、トランスクリプトに通知が表示されます
* Amazon Bedrock または Google Cloud の Agent Platform スタートアップチェックがデフォルトモデルが利用不可であることを検出します
* [自動モデルフォールバック](/docs/ja/model-config#automatic-model-fallback) は Fable 5.1、Fable 5、Opus 5 でセッションをフラグが付いたカテゴリのフォールバックモデルに移動し、そのカテゴリにフォールバックモデルがある場合、トランスクリプトに通知が表示されます

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
