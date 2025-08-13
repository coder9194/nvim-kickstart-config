return {
  name = "Start Dev Server",
  builder = function()
    print("Dev server is starting")

    return {
      cmd = "source ~/.zshrc && vfox use maven@3.6.3 && vfox use java@8.0.432+6-zulu && mvn spring-boot:run -Dspring-boot.run.profiles=dev",
      components = { "default", "unique" },
    }
  end,
}
