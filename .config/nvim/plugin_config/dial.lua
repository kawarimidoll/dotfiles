local augend = require('dial.augend')
require('dial.config').augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.semver.alias.semver,
    augend.date.alias['%Y/%m/%d'],
    augend.date.alias['%Y-%m-%d'],
    augend.date.alias['%m/%d'],
    augend.date.alias['%-m/%-d'],
    augend.date.alias['%H:%M:%S'],
    augend.date.alias['%H:%M'],
    augend.constant.alias.bool,
    augend.constant.alias.ja_weekday,
    augend.constant.alias.ja_weekday_full,
    augend.constant.new({ elements = { 'and', 'or' } }),
    augend.constant.new({
      elements = { '&&', '||' },
      word = false,
    }),
    augend.constant.new({ elements = { 'let', 'const' } }),
    augend.user.new({
      find = require('dial.augend.common').find_pattern('%u+'),
      add = function(text, _, _)
        return {
          text = text:lower(),
          cursor = #text,
        }
      end,
    }),
    augend.user.new({
      find = require('dial.augend.common').find_pattern('%u%l+'),
      add = function(text, _, _)
        return {
          text = text:upper(),
          cursor = #text,
        }
      end,
    }),
    augend.user.new({
      find = require('dial.augend.common').find_pattern('%l+'),
      add = function(text, _, _)
        return {
          text = text:sub(1, 1):upper() .. text:sub(2),
          cursor = #text,
        }
      end,
    }),
    augend.case.new({
      types = {
        'PascalCase',
        'camelCase',
        'kebab-case',
        'snake_case',
        'SCREAMING_SNAKE_CASE',
      },
    }),
  },
})
