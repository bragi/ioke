Number zero? = method(
  "Returns true if this number is zero.",
  @ == 0
)

Number negation = method(
  "Returns the negation of this number",

  0 - @)

Number abs = method(
  "Returns the absolute value of this number",
  if(self < 0, negation, self)
)

Number toJson = method(
  "Returns JSON representation of the object",
  asText
)

Number Ratio toJson = method(
  "Returns JSON representation of the object",
  (0.0 + self) asText
)

Number          do(=== = generateMatchMethod(==))
Number Real     do(=== = generateMatchMethod(==))
Number Rational do(=== = generateMatchMethod(==))
Number Decimal  do(=== = generateMatchMethod(==))
