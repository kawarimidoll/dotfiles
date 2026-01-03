return {
  workspace_required = true,
  settings = {
    emmylua = {
      workspace = {
        library = {
          -- シンボリックリンクだとうまく認識しない?
          -- vim.env.XDG_CONFIG_HOME .. '/emmylua',
          vim.env.HOME .. '/dotfiles/.config/emmylua',
        },
      },
    },
  },
}
