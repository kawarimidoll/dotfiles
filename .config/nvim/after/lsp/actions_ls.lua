-- https://github.com/actions/languageservices/tree/main/languageserver#3-create-the-lsp-configuration

local function get_github_token()
  local handle = io.popen("gh auth token 2>/dev/null")
  if not handle then return nil end
  local token = handle: read("*a"):gsub("%s+", "")
  handle:close()
  return token ~= "" and token or nil
end

local function parse_github_remote(url)
  if not url or url == "" then return nil end

  -- SSH format: git@github.com:owner/repo.git
  local owner, repo = url:match("git@github%.com:([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo: gsub("%.git$", "")
  end

  -- HTTPS format: https://github.com/owner/repo.git
  owner, repo = url:match("github%.com/([^/]+)/([^/%.]+)")
  if owner and repo then
    return owner, repo:gsub("%.git$", "")
  end

  return nil
end

local function get_repo_info(owner, repo)
  local cmd = string.format(
    "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.type}}' 2>/dev/null",
    owner,
    repo
  )
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle: read("*a"):gsub("%s+$", "")
  handle:close()

  local id, owner_type = result:match("^(%d+)\t(.+)$")
  if id then
    return {
      id = tonumber(id),
      organizationOwned = owner_type == "Organization",
    }
  end
  return nil
end

local function get_repos_config()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then return nil end
  local git_root = handle: read("*a"):gsub("%s+", "")
  handle:close()

  if git_root == "" then return nil end

  handle = io.popen("git remote get-url origin 2>/dev/null")
  if not handle then return nil end
  local remote_url = handle:read("*a"):gsub("%s+", "")
  handle:close()

  local owner, name = parse_github_remote(remote_url)
  if not owner or not name then return nil end

  local info = get_repo_info(owner, name)

  return {
    {
      id = info and info.id or 0,
      owner = owner,
      name = name,
      organizationOwned = info and info.organizationOwned or false,
      workspaceUri = "file://" .. git_root,
    },
  }
end

return {
  cmd = { "actions-languageserver", "--stdio" },
  filetypes = { 'yaml.github-actions' },
  root_markers = { ".git" },
  init_options = {
    -- Optional: provide a GitHub token and repo context for added functionality
    -- (e.g., repository-specific completions)
    sessionToken = get_github_token(),
    -- repos = get_repos_config(),
  },
}
