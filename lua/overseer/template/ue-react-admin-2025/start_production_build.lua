return {
  name = 'Start Production Build',
  builder = function()
    print 'Production build is starting'

    return {
      cmd = 'source ~/.zshrc && nvm use 22 && npm install && npm run build',
      components = { 'default', 'unique' },
    }
  end,
}
