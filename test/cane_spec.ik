use("ispec")
use("cane")

describe(Cane,
  it("loads cane storage paths from properties file",
    let(Cane configurationFileFullPath, "test/_cane/cane.properties",
      Cane caneStoragePaths should == ["test/_cane"]
    )
  )

  it("returns cane path if it exists",
    let(Cane canePaths, ["test/_cane"],
      Cane canePath("cane1") should == "test/_cane/cane1"
    )
  )

  it("loads cane properly",
    let(Cane configurationFileFullPath, "test/_cane/cane.properties",
      cane("cane1")
      Ground foo2HasBeenLoaded should == 42
    )
  )

  it("errors when cane does not exist",
    fn(
      let(Cane configurationFileFullPath, "test/_cane/cane.properties",
        cane("canex")
        Ground foo2HasBeenLoaded should == 42
      )
    ) should signal(Cane Conditions CaneNotFound)
  )
)
