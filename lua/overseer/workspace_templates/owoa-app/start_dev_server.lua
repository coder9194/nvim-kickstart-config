print 'Dev server is starting'

require('overseer')
  .new_task({

    cmd = 'cd ./app && npx vite --port 4200',
    components = { 'default', 'unique' },
  })
  :start()
