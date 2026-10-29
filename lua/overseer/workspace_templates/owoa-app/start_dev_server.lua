return {
  name = 'Start vite Dev Server',
  builder = function()
    print 'Dev server is starting'

    return {
      cmd = 'cd ./app && npx vite --port 4200',
      components = { 'default', 'unique' },
    }
  end,
}
