nil toJson = "null"
true toJson = "true"
false toJson = "false"

Number toJson = method(
  "Returns JSON representation of the object",
  asText
)

Number Ratio toJson = method(
  "Returns JSON representation of the object",
  (0.0 + self) asText
)

List toJson = method(
  "Returns JSON representation of the object",
  "[%s]" % select(cell?(:toJson)) map(toJson) join(", ")
)

Dict toJson = method(
  availableItems = select(pair, (pair key cell?(:toJson)) && (pair value cell?(:toJson)))
  jsonisedItems = availableItems map(pair, "%s : %s" % list(pair key toJson, pair value toJson))
  "{%s}" % jsonisedItems join(", ")
)

Regexp toJson = method(
  inspect[1..-1]
)
