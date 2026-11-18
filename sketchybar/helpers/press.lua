-- The "button press" animation used throughout the bar: the item drops
-- into its shadow and springs back. `pad` is the resting
-- { left, right } padding of the item.
return function(item, pad)
  pad = pad or { 4, 4 }
  sbar.animate("tanh", 8, function()
    item:set {
      background = { shadow = { distance = 0 } },
      y_offset = -4,
      padding_left = pad[1] + 4,
      padding_right = pad[2] - 4,
    }
    item:set {
      background = { shadow = { distance = 4 } },
      y_offset = 0,
      padding_left = pad[1],
      padding_right = pad[2],
    }
  end)
end
