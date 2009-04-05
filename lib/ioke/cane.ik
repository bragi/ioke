Cane = Origin mimic

Cane Conditions = Origin mimic
Cane Conditions CaneNotFound = Condition Error mimic

Cane do(
  configurationDirectory = System userHome
  configurationFileName = ".cane.properties"
  configurationFileFullPath = "#{configurationDirectory}/#{configurationFileName}"

  caneStoragePaths = method(
    ; Quick hack, use java:util:Properties later on
    self caneStoragePaths = FileSystem readFully(configurationFileFullPath) split("\n") first split("=") last split(":")
  )

  loadedCanes = []

  canePaths = []

  canePath = method(name,
    path = caneStoragePaths find(path,
      FileSystem exists?("#{path}/#{name}")
    )
    if(path, "#{path}/#{name}")
  )

  uses = method(name,
    unless(loadedCanes include?(name),
      canePath = canePath(name)
      unless(canePath, error!(Cane Conditions CaneNotFound))
      System loadPath << canePath
      use("#{canePath}/init.ik")
      loadedCanes << name
    )
  )
)

Ground cane = method(name,
  Cane uses(name)
)
