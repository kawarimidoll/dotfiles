return {
  on_init = function(client)
    client.cancel_request = function(_, _, _, _)
      -- Disable cancel request to avoid crashing the server
      -- https://github.com/nolanderc/glsl_analyzer/issues/68
    end
  end,
}
