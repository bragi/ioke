use("ispec")

describe(Extension,
  it("should register native extension",
    Extension registered?("ioke.lang.test.TextExtension") should be false
    Text cell?("extended_via_native_extension?") should be false
    
    Extension register("ioke.lang.test.TextExtension") should be true
    Text cell?("extended_via_native_extension?") should be true
    Text extended_via_native_extension? should be true
    
    Extension register("ioke.lang.test.TextExtension") should be false
  )
)