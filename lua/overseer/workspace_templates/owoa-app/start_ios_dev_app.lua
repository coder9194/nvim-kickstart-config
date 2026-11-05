local NODE_MODES = { 'sit', 'uat', 'uat2' }

print 'iOS Dev App is starting'

vim.ui.select(NODE_MODES, { prompt = 'Select NODE_MODE' }, function(selected_node_mode)
  if not selected_node_mode then
    return
  end

  require('overseer')
    .new_task({
      cmd = 'cd ./app && NODE_MODE=' .. selected_node_mode .. ' npx cap run ios --host localhost --port 4200 -l -- --mode $NODE_MODE',
    })
    :start()
end)
