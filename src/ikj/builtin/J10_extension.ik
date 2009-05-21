Extension registeredExtensions = []

Extension register = method(
  "registers new native extension with given native class name.",
  className,
  if(registered?(className),
    false,
    
    _register(className)
    registeredExtensions << className
    true
  )
)

Extension registered? = method(
  "returns true if extension with given native class name was already registered and false otherwise.",
  className,
  registeredExtensions include?(className)
)