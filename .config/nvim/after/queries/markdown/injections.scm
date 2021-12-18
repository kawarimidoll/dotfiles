(fenced_code_block
  (info_string) @lang
  (code_fence_content) @content
  (#match? @lang "^(ts|typescript)(:.*)?$")
  (#set! language "typescript"))

(fenced_code_block
  (info_string) @lang
  (code_fence_content) @content
  (#match? @lang "^(js|javascript)(:.*)?$")
  (#set! language "javascript"))

(fenced_code_block
  (info_string) @lang
  (code_fence_content) @content
  (#match? @lang "^(sh)(:.*)?$")
  (#set! language "bash"))
