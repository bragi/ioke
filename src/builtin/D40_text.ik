
Text aliasMethod("internal:concatenateText", "+")

Text empty? = method(
  "returns true if the length of this text is exactly zero, otherwise false",

  length == 0)

Text cell("*") = method(
  "returns the text repeated as many times as the argument. 0 and negative means no times",
  times,

  result = ""
  counted = 0
  times times(result += self)
  result)

Text cell("%") = method(
  "takes either a single argument or a list of arguments and sends these on to 'format'",
  formatSpec,
  if(formatSpec mimics?(List),
    self format(*formatSpec),
    self format(formatSpec)))

Text cell("=~") = method(
  "takes a regular expression, and tries to match that regular expression against the the self",
  regexp,
  regexp =~ self)

Text cell("!~") = method(
  "takes a regular expression, and tries to see if that expression doesn't match the text",
  regexp,
  regexp !~ self)

Text do(=== = generateMatchMethod(==))

Text chars = method(
	"returns a list of each character in this text",
	
	self split(""))
	
Text truncate = method(
  "returns text truncated to length characters (default: 30) if it is longer than length. When truncated, last characters are replaced by given omission (default: \"...\")",
  length: 30, omission: "...",
  
  if(self length <= length,
    self,
    
    if(length < omission length,
      error!("Truncated length is smaller than omission length")
    )
    cutLength = length - omission length - 1
    self[0..cutLength] + omission
  )
)

Text ?| = dmacro(
  "if this text is empty, returns the result of evaluating the argument, otherwise returns the text",

  [theCode]
  if(empty?,
    call argAt(0),
    self))

Text ?& = dmacro(
  "if this text is non-empty, returns the result of evaluating the argument, otherwise returns the text",

  [theCode]
  unless(empty?,
    call argAt(0),
    self))
  
Text script = method("returns a symbol representing the script (from the Unicode Character Database) of the first character of this Text"
  if(self length != 1, error!("Text does not contain exactly one character"))
  case(self[0],
    0x0FFFF, :Unknown,
    (0x0000..0x001F), :Common,
    0x0020, :Common,
    (0x0021..0x0023), :Common,
    0x0024, :Common,
    (0x0025..0x0027), :Common,
    0x0028, :Common,
    0x0029, :Common,
    0x002A, :Common,
    0x002B, :Common,
    0x002C, :Common,
    0x002D, :Common,
    (0x002E..0x002F), :Common,
    (0x0030..0x0039), :Common,
    (0x003A..0x003B), :Common,
    (0x003C..0x003E), :Common,
    (0x003F..0x0040), :Common,
    0x005B, :Common,
    0x005C, :Common,
    0x005D, :Common,
    0x005E, :Common,
    0x005F, :Common,
    0x0060, :Common,
    0x007B, :Common,
    0x007C, :Common,
    0x007D, :Common,
    0x007E, :Common,
    (0x007F..0x009F), :Common,
    0x00A0, :Common,
    0x00A1, :Common,
    (0x00A2..0x00A5), :Common,
    (0x00A6..0x00A7), :Common,
    0x00A8, :Common,
    0x00A9, :Common,
    0x00AB, :Common,
    0x00AC, :Common,
    0x00AD, :Common,
    0x00AE, :Common,
    0x00AF, :Common,
    0x00B0, :Common,
    0x00B1, :Common,
    (0x00B2..0x00B3), :Common,
    0x00B4, :Common,
    0x00B5, :Common,
    0x00B6, :Common,
    0x00B7, :Common,
    0x00B8, :Common,
    0x00B9, :Common,
    0x00BB, :Common,
    (0x00BC..0x00BE), :Common,
    0x00BF, :Common,
    0x00D7, :Common,
    0x00F7, :Common,
    (0x02B9..0x02C1), :Common,
    (0x02C2..0x02C5), :Common,
    (0x02C6..0x02D1), :Common,
    (0x02D2..0x02DF), :Common,
    (0x02E5..0x02EB), :Common,
    0x02EC, :Common,
    0x02ED, :Common,
    0x02EE, :Common,
    (0x02EF..0x02FF), :Common,
    0x0374, :Common,
    0x037E, :Common,
    0x0385, :Common,
    0x0387, :Common,
    0x0589, :Common,
    (0x0600..0x0603), :Common,
    0x060C, :Common,
    0x061B, :Common,
    0x061F, :Common,
    0x0640, :Common,
    (0x0660..0x0669), :Common,
    0x06DD, :Common,
    (0x0964..0x0965), :Common,
    0x0970, :Common,
    (0x0CF1..0x0CF2), :Common,
    0x0E3F, :Common,
    0x10FB, :Common,
    (0x16EB..0x16ED), :Common,
    (0x1735..0x1736), :Common,
    (0x1802..0x1803), :Common,
    0x1805, :Common,
    (0x2000..0x200A), :Common,
    0x200B, :Common,
    (0x200E..0x200F), :Common,
    (0x2010..0x2015), :Common,
    (0x2016..0x2017), :Common,
    0x2018, :Common,
    0x2019, :Common,
    0x201A, :Common,
    (0x201B..0x201C), :Common,
    0x201D, :Common,
    0x201E, :Common,
    0x201F, :Common,
    (0x2020..0x2027), :Common,
    0x2028, :Common,
    0x2029, :Common,
    (0x202A..0x202E), :Common,
    0x202F, :Common,
    (0x2030..0x2038), :Common,
    0x2039, :Common,
    0x203A, :Common,
    (0x203B..0x203E), :Common,
    (0x203F..0x2040), :Common,
    (0x2041..0x2043), :Common,
    0x2044, :Common,
    0x2045, :Common,
    0x2046, :Common,
    (0x2047..0x2051), :Common,
    0x2052, :Common,
    0x2053, :Common,
    0x2054, :Common,
    (0x2055..0x205E), :Common,
    0x205F, :Common,
    (0x2060..0x2064), :Common,
    (0x206A..0x206F), :Common,
    0x2070, :Common,
    (0x2074..0x2079), :Common,
    (0x207A..0x207C), :Common,
    0x207D, :Common,
    0x207E, :Common,
    (0x2080..0x2089), :Common,
    (0x208A..0x208C), :Common,
    0x208D, :Common,
    0x208E, :Common,
    (0x20A0..0x20B5), :Common,
    (0x2100..0x2101), :Common,
    0x2102, :Common,
    (0x2103..0x2106), :Common,
    0x2107, :Common,
    (0x2108..0x2109), :Common,
    (0x210A..0x2113), :Common,
    0x2114, :Common,
    0x2115, :Common,
    (0x2116..0x2118), :Common,
    (0x2119..0x211D), :Common,
    (0x211E..0x2123), :Common,
    0x2124, :Common,
    0x2125, :Common,
    0x2127, :Common,
    0x2128, :Common,
    0x2129, :Common,
    (0x212C..0x212D), :Common,
    0x212E, :Common,
    (0x212F..0x2131), :Common,
    (0x2133..0x2134), :Common,
    (0x2135..0x2138), :Common,
    0x2139, :Common,
    (0x213A..0x213B), :Common,
    (0x213C..0x213F), :Common,
    (0x2140..0x2144), :Common,
    (0x2145..0x2149), :Common,
    0x214A, :Common,
    0x214B, :Common,
    (0x214C..0x214D), :Common,
    0x214F, :Common,
    (0x2153..0x215F), :Common,
    (0x2190..0x2194), :Common,
    (0x2195..0x2199), :Common,
    (0x219A..0x219B), :Common,
    (0x219C..0x219F), :Common,
    0x21A0, :Common,
    (0x21A1..0x21A2), :Common,
    0x21A3, :Common,
    (0x21A4..0x21A5), :Common,
    0x21A6, :Common,
    (0x21A7..0x21AD), :Common,
    0x21AE, :Common,
    (0x21AF..0x21CD), :Common,
    (0x21CE..0x21CF), :Common,
    (0x21D0..0x21D1), :Common,
    0x21D2, :Common,
    0x21D3, :Common,
    0x21D4, :Common,
    (0x21D5..0x21F3), :Common,
    (0x21F4..0x22FF), :Common,
    (0x2300..0x2307), :Common,
    (0x2308..0x230B), :Common,
    (0x230C..0x231F), :Common,
    (0x2320..0x2321), :Common,
    (0x2322..0x2328), :Common,
    0x2329, :Common,
    0x232A, :Common,
    (0x232B..0x237B), :Common,
    0x237C, :Common,
    (0x237D..0x239A), :Common,
    (0x239B..0x23B3), :Common,
    (0x23B4..0x23DB), :Common,
    (0x23DC..0x23E1), :Common,
    (0x23E2..0x23E7), :Common,
    (0x2400..0x2426), :Common,
    (0x2440..0x244A), :Common,
    (0x2460..0x249B), :Common,
    (0x249C..0x24E9), :Common,
    (0x24EA..0x24FF), :Common,
    (0x2500..0x25B6), :Common,
    0x25B7, :Common,
    (0x25B8..0x25C0), :Common,
    0x25C1, :Common,
    (0x25C2..0x25F7), :Common,
    (0x25F8..0x25FF), :Common,
    (0x2600..0x266E), :Common,
    0x266F, :Common,
    (0x2670..0x269D), :Common,
    (0x26A0..0x26BC), :Common,
    (0x26C0..0x26C3), :Common,
    (0x2701..0x2704), :Common,
    (0x2706..0x2709), :Common,
    (0x270C..0x2727), :Common,
    (0x2729..0x274B), :Common,
    0x274D, :Common,
    (0x274F..0x2752), :Common,
    0x2756, :Common,
    (0x2758..0x275E), :Common,
    (0x2761..0x2767), :Common,
    0x2768, :Common,
    0x2769, :Common,
    0x276A, :Common,
    0x276B, :Common,
    0x276C, :Common,
    0x276D, :Common,
    0x276E, :Common,
    0x276F, :Common,
    0x2770, :Common,
    0x2771, :Common,
    0x2772, :Common,
    0x2773, :Common,
    0x2774, :Common,
    0x2775, :Common,
    (0x2776..0x2793), :Common,
    0x2794, :Common,
    (0x2798..0x27AF), :Common,
    (0x27B1..0x27BE), :Common,
    (0x27C0..0x27C4), :Common,
    0x27C5, :Common,
    0x27C6, :Common,
    (0x27C7..0x27CA), :Common,
    0x27CC, :Common,
    (0x27D0..0x27E5), :Common,
    0x27E6, :Common,
    0x27E7, :Common,
    0x27E8, :Common,
    0x27E9, :Common,
    0x27EA, :Common,
    0x27EB, :Common,
    0x27EC, :Common,
    0x27ED, :Common,
    0x27EE, :Common,
    0x27EF, :Common,
    (0x27F0..0x27FF), :Common,
    (0x2900..0x2982), :Common,
    0x2983, :Common,
    0x2984, :Common,
    0x2985, :Common,
    0x2986, :Common,
    0x2987, :Common,
    0x2988, :Common,
    0x2989, :Common,
    0x298A, :Common,
    0x298B, :Common,
    0x298C, :Common,
    0x298D, :Common,
    0x298E, :Common,
    0x298F, :Common,
    0x2990, :Common,
    0x2991, :Common,
    0x2992, :Common,
    0x2993, :Common,
    0x2994, :Common,
    0x2995, :Common,
    0x2996, :Common,
    0x2997, :Common,
    0x2998, :Common,
    (0x2999..0x29D7), :Common,
    0x29D8, :Common,
    0x29D9, :Common,
    0x29DA, :Common,
    0x29DB, :Common,
    (0x29DC..0x29FB), :Common,
    0x29FC, :Common,
    0x29FD, :Common,
    (0x29FE..0x2AFF), :Common,
    (0x2B00..0x2B2F), :Common,
    (0x2B30..0x2B44), :Common,
    (0x2B45..0x2B46), :Common,
    (0x2B47..0x2B4C), :Common,
    (0x2B50..0x2B54), :Common,
    (0x2E00..0x2E01), :Common,
    0x2E02, :Common,
    0x2E03, :Common,
    0x2E04, :Common,
    0x2E05, :Common,
    (0x2E06..0x2E08), :Common,
    0x2E09, :Common,
    0x2E0A, :Common,
    0x2E0B, :Common,
    0x2E0C, :Common,
    0x2E0D, :Common,
    (0x2E0E..0x2E16), :Common,
    0x2E17, :Common,
    (0x2E18..0x2E19), :Common,
    0x2E1A, :Common,
    0x2E1B, :Common,
    0x2E1C, :Common,
    0x2E1D, :Common,
    (0x2E1E..0x2E1F), :Common,
    0x2E20, :Common,
    0x2E21, :Common,
    0x2E22, :Common,
    0x2E23, :Common,
    0x2E24, :Common,
    0x2E25, :Common,
    0x2E26, :Common,
    0x2E27, :Common,
    0x2E28, :Common,
    0x2E29, :Common,
    (0x2E2A..0x2E2E), :Common,
    0x2E2F, :Common,
    0x2E30, :Common,
    (0x2FF0..0x2FFB), :Common,
    0x3000, :Common,
    (0x3001..0x3003), :Common,
    0x3004, :Common,
    0x3006, :Common,
    0x3008, :Common,
    0x3009, :Common,
    0x300A, :Common,
    0x300B, :Common,
    0x300C, :Common,
    0x300D, :Common,
    0x300E, :Common,
    0x300F, :Common,
    0x3010, :Common,
    0x3011, :Common,
    (0x3012..0x3013), :Common,
    0x3014, :Common,
    0x3015, :Common,
    0x3016, :Common,
    0x3017, :Common,
    0x3018, :Common,
    0x3019, :Common,
    0x301A, :Common,
    0x301B, :Common,
    0x301C, :Common,
    0x301D, :Common,
    (0x301E..0x301F), :Common,
    0x3020, :Common,
    0x3030, :Common,
    (0x3031..0x3035), :Common,
    (0x3036..0x3037), :Common,
    0x303C, :Common,
    0x303D, :Common,
    (0x303E..0x303F), :Common,
    (0x309B..0x309C), :Common,
    0x30A0, :Common,
    0x30FB, :Common,
    0x30FC, :Common,
    (0x3190..0x3191), :Common,
    (0x3192..0x3195), :Common,
    (0x3196..0x319F), :Common,
    (0x31C0..0x31E3), :Common,
    (0x3220..0x3229), :Common,
    (0x322A..0x3243), :Common,
    0x3250, :Common,
    (0x3251..0x325F), :Common,
    0x327F, :Common,
    (0x3280..0x3289), :Common,
    (0x328A..0x32B0), :Common,
    (0x32B1..0x32BF), :Common,
    (0x32C0..0x32CF), :Common,
    (0x3358..0x33FF), :Common,
    (0x4DC0..0x4DFF), :Common,
    (0xA700..0xA716), :Common,
    (0xA717..0xA71F), :Common,
    (0xA720..0xA721), :Common,
    0xA788, :Common,
    (0xA789..0xA78A), :Common,
    0xFD3E, :Common,
    0xFD3F, :Common,
    0xFDFD, :Common,
    (0xFE10..0xFE16), :Common,
    0xFE17, :Common,
    0xFE18, :Common,
    0xFE19, :Common,
    0xFE30, :Common,
    (0xFE31..0xFE32), :Common,
    (0xFE33..0xFE34), :Common,
    0xFE35, :Common,
    0xFE36, :Common,
    0xFE37, :Common,
    0xFE38, :Common,
    0xFE39, :Common,
    0xFE3A, :Common,
    0xFE3B, :Common,
    0xFE3C, :Common,
    0xFE3D, :Common,
    0xFE3E, :Common,
    0xFE3F, :Common,
    0xFE40, :Common,
    0xFE41, :Common,
    0xFE42, :Common,
    0xFE43, :Common,
    0xFE44, :Common,
    (0xFE45..0xFE46), :Common,
    0xFE47, :Common,
    0xFE48, :Common,
    (0xFE49..0xFE4C), :Common,
    (0xFE4D..0xFE4F), :Common,
    (0xFE50..0xFE52), :Common,
    (0xFE54..0xFE57), :Common,
    0xFE58, :Common,
    0xFE59, :Common,
    0xFE5A, :Common,
    0xFE5B, :Common,
    0xFE5C, :Common,
    0xFE5D, :Common,
    0xFE5E, :Common,
    (0xFE5F..0xFE61), :Common,
    0xFE62, :Common,
    0xFE63, :Common,
    (0xFE64..0xFE66), :Common,
    0xFE68, :Common,
    0xFE69, :Common,
    (0xFE6A..0xFE6B), :Common,
    0xFEFF, :Common,
    (0xFF01..0xFF03), :Common,
    0xFF04, :Common,
    (0xFF05..0xFF07), :Common,
    0xFF08, :Common,
    0xFF09, :Common,
    0xFF0A, :Common,
    0xFF0B, :Common,
    0xFF0C, :Common,
    0xFF0D, :Common,
    (0xFF0E..0xFF0F), :Common,
    (0xFF10..0xFF19), :Common,
    (0xFF1A..0xFF1B), :Common,
    (0xFF1C..0xFF1E), :Common,
    (0xFF1F..0xFF20), :Common,
    0xFF3B, :Common,
    0xFF3C, :Common,
    0xFF3D, :Common,
    0xFF3E, :Common,
    0xFF3F, :Common,
    0xFF40, :Common,
    0xFF5B, :Common,
    0xFF5C, :Common,
    0xFF5D, :Common,
    0xFF5E, :Common,
    0xFF5F, :Common,
    0xFF60, :Common,
    0xFF61, :Common,
    0xFF62, :Common,
    0xFF63, :Common,
    (0xFF64..0xFF65), :Common,
    0xFF70, :Common,
    (0xFF9E..0xFF9F), :Common,
    (0xFFE0..0xFFE1), :Common,
    0xFFE2, :Common,
    0xFFE3, :Common,
    0xFFE4, :Common,
    (0xFFE5..0xFFE6), :Common,
    0xFFE8, :Common,
    (0xFFE9..0xFFEC), :Common,
    (0xFFED..0xFFEE), :Common,
    (0xFFF9..0xFFFB), :Common,
    (0xFFFC..0xFFFD), :Common,
    (0x10100..0x10101), :Common,
    0x10102, :Common,
    (0x10107..0x10133), :Common,
    (0x10137..0x1013F), :Common,
    (0x10190..0x1019B), :Common,
    (0x101D0..0x101FC), :Common,
    (0x1D000..0x1D0F5), :Common,
    (0x1D100..0x1D126), :Common,
    (0x1D129..0x1D164), :Common,
    (0x1D165..0x1D166), :Common,
    (0x1D16A..0x1D16C), :Common,
    (0x1D16D..0x1D172), :Common,
    (0x1D173..0x1D17A), :Common,
    (0x1D183..0x1D184), :Common,
    (0x1D18C..0x1D1A9), :Common,
    (0x1D1AE..0x1D1DD), :Common,
    (0x1D300..0x1D356), :Common,
    (0x1D360..0x1D371), :Common,
    (0x1D400..0x1D454), :Common,
    (0x1D456..0x1D49C), :Common,
    (0x1D49E..0x1D49F), :Common,
    0x1D4A2, :Common,
    (0x1D4A5..0x1D4A6), :Common,
    (0x1D4A9..0x1D4AC), :Common,
    (0x1D4AE..0x1D4B9), :Common,
    0x1D4BB, :Common,
    (0x1D4BD..0x1D4C3), :Common,
    (0x1D4C5..0x1D505), :Common,
    (0x1D507..0x1D50A), :Common,
    (0x1D50D..0x1D514), :Common,
    (0x1D516..0x1D51C), :Common,
    (0x1D51E..0x1D539), :Common,
    (0x1D53B..0x1D53E), :Common,
    (0x1D540..0x1D544), :Common,
    0x1D546, :Common,
    (0x1D54A..0x1D550), :Common,
    (0x1D552..0x1D6A5), :Common,
    (0x1D6A8..0x1D6C0), :Common,
    0x1D6C1, :Common,
    (0x1D6C2..0x1D6DA), :Common,
    0x1D6DB, :Common,
    (0x1D6DC..0x1D6FA), :Common,
    0x1D6FB, :Common,
    (0x1D6FC..0x1D714), :Common,
    0x1D715, :Common,
    (0x1D716..0x1D734), :Common,
    0x1D735, :Common,
    (0x1D736..0x1D74E), :Common,
    0x1D74F, :Common,
    (0x1D750..0x1D76E), :Common,
    0x1D76F, :Common,
    (0x1D770..0x1D788), :Common,
    0x1D789, :Common,
    (0x1D78A..0x1D7A8), :Common,
    0x1D7A9, :Common,
    (0x1D7AA..0x1D7C2), :Common,
    0x1D7C3, :Common,
    (0x1D7C4..0x1D7CB), :Common,
    (0x1D7CE..0x1D7FF), :Common,
    (0x1F000..0x1F02B), :Common,
    (0x1F030..0x1F093), :Common,
    0xE0001, :Common,
    (0xE0020..0xE007F), :Common,
    (0x0041..0x005A), :Latin,
    (0x0061..0x007A), :Latin,
    0x00AA, :Latin,
    0x00BA, :Latin,
    (0x00C0..0x00D6), :Latin,
    (0x00D8..0x00F6), :Latin,
    (0x00F8..0x01BA), :Latin,
    0x01BB, :Latin,
    (0x01BC..0x01BF), :Latin,
    (0x01C0..0x01C3), :Latin,
    (0x01C4..0x0293), :Latin,
    0x0294, :Latin,
    (0x0295..0x02AF), :Latin,
    (0x02B0..0x02B8), :Latin,
    (0x02E0..0x02E4), :Latin,
    (0x1D00..0x1D25), :Latin,
    (0x1D2C..0x1D5C), :Latin,
    (0x1D62..0x1D65), :Latin,
    (0x1D6B..0x1D77), :Latin,
    (0x1D79..0x1D9A), :Latin,
    (0x1D9B..0x1DBE), :Latin,
    (0x1E00..0x1EFF), :Latin,
    0x2071, :Latin,
    0x207F, :Latin,
    (0x2090..0x2094), :Latin,
    (0x212A..0x212B), :Latin,
    0x2132, :Latin,
    0x214E, :Latin,
    (0x2160..0x2182), :Latin,
    (0x2183..0x2184), :Latin,
    (0x2185..0x2188), :Latin,
    (0x2C60..0x2C6F), :Latin,
    (0x2C71..0x2C7C), :Latin,
    0x2C7D, :Latin,
    (0xA722..0xA76F), :Latin,
    0xA770, :Latin,
    (0xA771..0xA787), :Latin,
    (0xA78B..0xA78C), :Latin,
    (0xA7FB..0xA7FF), :Latin,
    (0xFB00..0xFB06), :Latin,
    (0xFF21..0xFF3A), :Latin,
    (0xFF41..0xFF5A), :Latin,
    (0x0370..0x0373), :Greek,
    0x0375, :Greek,
    (0x0376..0x0377), :Greek,
    0x037A, :Greek,
    (0x037B..0x037D), :Greek,
    0x0384, :Greek,
    0x0386, :Greek,
    (0x0388..0x038A), :Greek,
    0x038C, :Greek,
    (0x038E..0x03A1), :Greek,
    (0x03A3..0x03E1), :Greek,
    (0x03F0..0x03F5), :Greek,
    0x03F6, :Greek,
    (0x03F7..0x03FF), :Greek,
    (0x1D26..0x1D2A), :Greek,
    (0x1D5D..0x1D61), :Greek,
    (0x1D66..0x1D6A), :Greek,
    0x1DBF, :Greek,
    (0x1F00..0x1F15), :Greek,
    (0x1F18..0x1F1D), :Greek,
    (0x1F20..0x1F45), :Greek,
    (0x1F48..0x1F4D), :Greek,
    (0x1F50..0x1F57), :Greek,
    0x1F59, :Greek,
    0x1F5B, :Greek,
    0x1F5D, :Greek,
    (0x1F5F..0x1F7D), :Greek,
    (0x1F80..0x1FB4), :Greek,
    (0x1FB6..0x1FBC), :Greek,
    0x1FBD, :Greek,
    0x1FBE, :Greek,
    (0x1FBF..0x1FC1), :Greek,
    (0x1FC2..0x1FC4), :Greek,
    (0x1FC6..0x1FCC), :Greek,
    (0x1FCD..0x1FCF), :Greek,
    (0x1FD0..0x1FD3), :Greek,
    (0x1FD6..0x1FDB), :Greek,
    (0x1FDD..0x1FDF), :Greek,
    (0x1FE0..0x1FEC), :Greek,
    (0x1FED..0x1FEF), :Greek,
    (0x1FF2..0x1FF4), :Greek,
    (0x1FF6..0x1FFC), :Greek,
    (0x1FFD..0x1FFE), :Greek,
    0x2126, :Greek,
    (0x10140..0x10174), :Greek,
    (0x10175..0x10178), :Greek,
    (0x10179..0x10189), :Greek,
    0x1018A, :Greek,
    (0x1D200..0x1D241), :Greek,
    (0x1D242..0x1D244), :Greek,
    0x1D245, :Greek,
    (0x0400..0x0481), :Cyrillic,
    0x0482, :Cyrillic,
    (0x0483..0x0487), :Cyrillic,
    (0x0488..0x0489), :Cyrillic,
    (0x048A..0x0523), :Cyrillic,
    0x1D2B, :Cyrillic,
    0x1D78, :Cyrillic,
    (0x2DE0..0x2DFF), :Cyrillic,
    (0xA640..0xA65F), :Cyrillic,
    (0xA662..0xA66D), :Cyrillic,
    0xA66E, :Cyrillic,
    0xA66F, :Cyrillic,
    (0xA670..0xA672), :Cyrillic,
    0xA673, :Cyrillic,
    (0xA67C..0xA67D), :Cyrillic,
    0xA67E, :Cyrillic,
    0xA67F, :Cyrillic,
    (0xA680..0xA697), :Cyrillic,
    (0x0531..0x0556), :Armenian,
    0x0559, :Armenian,
    (0x055A..0x055F), :Armenian,
    (0x0561..0x0587), :Armenian,
    0x058A, :Armenian,
    (0xFB13..0xFB17), :Armenian,
    (0x0591..0x05BD), :Hebrew,
    0x05BE, :Hebrew,
    0x05BF, :Hebrew,
    0x05C0, :Hebrew,
    (0x05C1..0x05C2), :Hebrew,
    0x05C3, :Hebrew,
    (0x05C4..0x05C5), :Hebrew,
    0x05C6, :Hebrew,
    0x05C7, :Hebrew,
    (0x05D0..0x05EA), :Hebrew,
    (0x05F0..0x05F2), :Hebrew,
    (0x05F3..0x05F4), :Hebrew,
    0xFB1D, :Hebrew,
    0xFB1E, :Hebrew,
    (0xFB1F..0xFB28), :Hebrew,
    0xFB29, :Hebrew,
    (0xFB2A..0xFB36), :Hebrew,
    (0xFB38..0xFB3C), :Hebrew,
    0xFB3E, :Hebrew,
    (0xFB40..0xFB41), :Hebrew,
    (0xFB43..0xFB44), :Hebrew,
    (0xFB46..0xFB4F), :Hebrew,
    (0x0606..0x0608), :Arabic,
    (0x0609..0x060A), :Arabic,
    0x060B, :Arabic,
    0x060D, :Arabic,
    (0x060E..0x060F), :Arabic,
    (0x0610..0x061A), :Arabic,
    0x061E, :Arabic,
    (0x0621..0x063F), :Arabic,
    (0x0641..0x064A), :Arabic,
    (0x0656..0x065E), :Arabic,
    (0x066A..0x066D), :Arabic,
    (0x066E..0x066F), :Arabic,
    (0x0671..0x06D3), :Arabic,
    0x06D4, :Arabic,
    0x06D5, :Arabic,
    (0x06D6..0x06DC), :Arabic,
    0x06DE, :Arabic,
    (0x06DF..0x06E4), :Arabic,
    (0x06E5..0x06E6), :Arabic,
    (0x06E7..0x06E8), :Arabic,
    0x06E9, :Arabic,
    (0x06EA..0x06ED), :Arabic,
    (0x06EE..0x06EF), :Arabic,
    (0x06F0..0x06F9), :Arabic,
    (0x06FA..0x06FC), :Arabic,
    (0x06FD..0x06FE), :Arabic,
    0x06FF, :Arabic,
    (0x0750..0x077F), :Arabic,
    (0xFB50..0xFBB1), :Arabic,
    (0xFBD3..0xFD3D), :Arabic,
    (0xFD50..0xFD8F), :Arabic,
    (0xFD92..0xFDC7), :Arabic,
    (0xFDF0..0xFDFB), :Arabic,
    0xFDFC, :Arabic,
    (0xFE70..0xFE74), :Arabic,
    (0xFE76..0xFEFC), :Arabic,
    (0x0700..0x070D), :Syriac,
    0x070F, :Syriac,
    0x0710, :Syriac,
    0x0711, :Syriac,
    (0x0712..0x072F), :Syriac,
    (0x0730..0x074A), :Syriac,
    (0x074D..0x074F), :Syriac,
    (0x0780..0x07A5), :Thaana,
    (0x07A6..0x07B0), :Thaana,
    0x07B1, :Thaana,
    (0x0901..0x0902), :Devanagari,
    0x0903, :Devanagari,
    (0x0904..0x0939), :Devanagari,
    0x093C, :Devanagari,
    0x093D, :Devanagari,
    (0x093E..0x0940), :Devanagari,
    (0x0941..0x0948), :Devanagari,
    (0x0949..0x094C), :Devanagari,
    0x094D, :Devanagari,
    0x0950, :Devanagari,
    (0x0953..0x0954), :Devanagari,
    (0x0958..0x0961), :Devanagari,
    (0x0962..0x0963), :Devanagari,
    (0x0966..0x096F), :Devanagari,
    0x0971, :Devanagari,
    0x0972, :Devanagari,
    (0x097B..0x097F), :Devanagari,
    0x0981, :Bengali,
    (0x0982..0x0983), :Bengali,
    (0x0985..0x098C), :Bengali,
    (0x098F..0x0990), :Bengali,
    (0x0993..0x09A8), :Bengali,
    (0x09AA..0x09B0), :Bengali,
    0x09B2, :Bengali,
    (0x09B6..0x09B9), :Bengali,
    0x09BC, :Bengali,
    0x09BD, :Bengali,
    (0x09BE..0x09C0), :Bengali,
    (0x09C1..0x09C4), :Bengali,
    (0x09C7..0x09C8), :Bengali,
    (0x09CB..0x09CC), :Bengali,
    0x09CD, :Bengali,
    0x09CE, :Bengali,
    0x09D7, :Bengali,
    (0x09DC..0x09DD), :Bengali,
    (0x09DF..0x09E1), :Bengali,
    (0x09E2..0x09E3), :Bengali,
    (0x09E6..0x09EF), :Bengali,
    (0x09F0..0x09F1), :Bengali,
    (0x09F2..0x09F3), :Bengali,
    (0x09F4..0x09F9), :Bengali,
    0x09FA, :Bengali,
    (0x0A01..0x0A02), :Gurmukhi,
    0x0A03, :Gurmukhi,
    (0x0A05..0x0A0A), :Gurmukhi,
    (0x0A0F..0x0A10), :Gurmukhi,
    (0x0A13..0x0A28), :Gurmukhi,
    (0x0A2A..0x0A30), :Gurmukhi,
    (0x0A32..0x0A33), :Gurmukhi,
    (0x0A35..0x0A36), :Gurmukhi,
    (0x0A38..0x0A39), :Gurmukhi,
    0x0A3C, :Gurmukhi,
    (0x0A3E..0x0A40), :Gurmukhi,
    (0x0A41..0x0A42), :Gurmukhi,
    (0x0A47..0x0A48), :Gurmukhi,
    (0x0A4B..0x0A4D), :Gurmukhi,
    0x0A51, :Gurmukhi,
    (0x0A59..0x0A5C), :Gurmukhi,
    0x0A5E, :Gurmukhi,
    (0x0A66..0x0A6F), :Gurmukhi,
    (0x0A70..0x0A71), :Gurmukhi,
    (0x0A72..0x0A74), :Gurmukhi,
    0x0A75, :Gurmukhi,
    (0x0A81..0x0A82), :Gujarati,
    0x0A83, :Gujarati,
    (0x0A85..0x0A8D), :Gujarati,
    (0x0A8F..0x0A91), :Gujarati,
    (0x0A93..0x0AA8), :Gujarati,
    (0x0AAA..0x0AB0), :Gujarati,
    (0x0AB2..0x0AB3), :Gujarati,
    (0x0AB5..0x0AB9), :Gujarati,
    0x0ABC, :Gujarati,
    0x0ABD, :Gujarati,
    (0x0ABE..0x0AC0), :Gujarati,
    (0x0AC1..0x0AC5), :Gujarati,
    (0x0AC7..0x0AC8), :Gujarati,
    0x0AC9, :Gujarati,
    (0x0ACB..0x0ACC), :Gujarati,
    0x0ACD, :Gujarati,
    0x0AD0, :Gujarati,
    (0x0AE0..0x0AE1), :Gujarati,
    (0x0AE2..0x0AE3), :Gujarati,
    (0x0AE6..0x0AEF), :Gujarati,
    0x0AF1, :Gujarati,
    0x0B01, :Oriya,
    (0x0B02..0x0B03), :Oriya,
    (0x0B05..0x0B0C), :Oriya,
    (0x0B0F..0x0B10), :Oriya,
    (0x0B13..0x0B28), :Oriya,
    (0x0B2A..0x0B30), :Oriya,
    (0x0B32..0x0B33), :Oriya,
    (0x0B35..0x0B39), :Oriya,
    0x0B3C, :Oriya,
    0x0B3D, :Oriya,
    0x0B3E, :Oriya,
    0x0B3F, :Oriya,
    0x0B40, :Oriya,
    (0x0B41..0x0B44), :Oriya,
    (0x0B47..0x0B48), :Oriya,
    (0x0B4B..0x0B4C), :Oriya,
    0x0B4D, :Oriya,
    0x0B56, :Oriya,
    0x0B57, :Oriya,
    (0x0B5C..0x0B5D), :Oriya,
    (0x0B5F..0x0B61), :Oriya,
    (0x0B62..0x0B63), :Oriya,
    (0x0B66..0x0B6F), :Oriya,
    0x0B70, :Oriya,
    0x0B71, :Oriya,
    0x0B82, :Tamil,
    0x0B83, :Tamil,
    (0x0B85..0x0B8A), :Tamil,
    (0x0B8E..0x0B90), :Tamil,
    (0x0B92..0x0B95), :Tamil,
    (0x0B99..0x0B9A), :Tamil,
    0x0B9C, :Tamil,
    (0x0B9E..0x0B9F), :Tamil,
    (0x0BA3..0x0BA4), :Tamil,
    (0x0BA8..0x0BAA), :Tamil,
    (0x0BAE..0x0BB9), :Tamil,
    (0x0BBE..0x0BBF), :Tamil,
    0x0BC0, :Tamil,
    (0x0BC1..0x0BC2), :Tamil,
    (0x0BC6..0x0BC8), :Tamil,
    (0x0BCA..0x0BCC), :Tamil,
    0x0BCD, :Tamil,
    0x0BD0, :Tamil,
    0x0BD7, :Tamil,
    (0x0BE6..0x0BEF), :Tamil,
    (0x0BF0..0x0BF2), :Tamil,
    (0x0BF3..0x0BF8), :Tamil,
    0x0BF9, :Tamil,
    0x0BFA, :Tamil,
    (0x0C01..0x0C03), :Telugu,
    (0x0C05..0x0C0C), :Telugu,
    (0x0C0E..0x0C10), :Telugu,
    (0x0C12..0x0C28), :Telugu,
    (0x0C2A..0x0C33), :Telugu,
    (0x0C35..0x0C39), :Telugu,
    0x0C3D, :Telugu,
    (0x0C3E..0x0C40), :Telugu,
    (0x0C41..0x0C44), :Telugu,
    (0x0C46..0x0C48), :Telugu,
    (0x0C4A..0x0C4D), :Telugu,
    (0x0C55..0x0C56), :Telugu,
    (0x0C58..0x0C59), :Telugu,
    (0x0C60..0x0C61), :Telugu,
    (0x0C62..0x0C63), :Telugu,
    (0x0C66..0x0C6F), :Telugu,
    (0x0C78..0x0C7E), :Telugu,
    0x0C7F, :Telugu,
    (0x0C82..0x0C83), :Kannada,
    (0x0C85..0x0C8C), :Kannada,
    (0x0C8E..0x0C90), :Kannada,
    (0x0C92..0x0CA8), :Kannada,
    (0x0CAA..0x0CB3), :Kannada,
    (0x0CB5..0x0CB9), :Kannada,
    0x0CBC, :Kannada,
    0x0CBD, :Kannada,
    0x0CBE, :Kannada,
    0x0CBF, :Kannada,
    (0x0CC0..0x0CC4), :Kannada,
    0x0CC6, :Kannada,
    (0x0CC7..0x0CC8), :Kannada,
    (0x0CCA..0x0CCB), :Kannada,
    (0x0CCC..0x0CCD), :Kannada,
    (0x0CD5..0x0CD6), :Kannada,
    0x0CDE, :Kannada,
    (0x0CE0..0x0CE1), :Kannada,
    (0x0CE2..0x0CE3), :Kannada,
    (0x0CE6..0x0CEF), :Kannada,
    (0x0D02..0x0D03), :Malayalam,
    (0x0D05..0x0D0C), :Malayalam,
    (0x0D0E..0x0D10), :Malayalam,
    (0x0D12..0x0D28), :Malayalam,
    (0x0D2A..0x0D39), :Malayalam,
    0x0D3D, :Malayalam,
    (0x0D3E..0x0D40), :Malayalam,
    (0x0D41..0x0D44), :Malayalam,
    (0x0D46..0x0D48), :Malayalam,
    (0x0D4A..0x0D4C), :Malayalam,
    0x0D4D, :Malayalam,
    0x0D57, :Malayalam,
    (0x0D60..0x0D61), :Malayalam,
    (0x0D62..0x0D63), :Malayalam,
    (0x0D66..0x0D6F), :Malayalam,
    (0x0D70..0x0D75), :Malayalam,
    0x0D79, :Malayalam,
    (0x0D7A..0x0D7F), :Malayalam,
    (0x0D82..0x0D83), :Sinhala,
    (0x0D85..0x0D96), :Sinhala,
    (0x0D9A..0x0DB1), :Sinhala,
    (0x0DB3..0x0DBB), :Sinhala,
    0x0DBD, :Sinhala,
    (0x0DC0..0x0DC6), :Sinhala,
    0x0DCA, :Sinhala,
    (0x0DCF..0x0DD1), :Sinhala,
    (0x0DD2..0x0DD4), :Sinhala,
    0x0DD6, :Sinhala,
    (0x0DD8..0x0DDF), :Sinhala,
    (0x0DF2..0x0DF3), :Sinhala,
    0x0DF4, :Sinhala,
    (0x0E01..0x0E30), :Thai,
    0x0E31, :Thai,
    (0x0E32..0x0E33), :Thai,
    (0x0E34..0x0E3A), :Thai,
    (0x0E40..0x0E45), :Thai,
    0x0E46, :Thai,
    (0x0E47..0x0E4E), :Thai,
    0x0E4F, :Thai,
    (0x0E50..0x0E59), :Thai,
    (0x0E5A..0x0E5B), :Thai,
    (0x0E81..0x0E82), :Lao,
    0x0E84, :Lao,
    (0x0E87..0x0E88), :Lao,
    0x0E8A, :Lao,
    0x0E8D, :Lao,
    (0x0E94..0x0E97), :Lao,
    (0x0E99..0x0E9F), :Lao,
    (0x0EA1..0x0EA3), :Lao,
    0x0EA5, :Lao,
    0x0EA7, :Lao,
    (0x0EAA..0x0EAB), :Lao,
    (0x0EAD..0x0EB0), :Lao,
    0x0EB1, :Lao,
    (0x0EB2..0x0EB3), :Lao,
    (0x0EB4..0x0EB9), :Lao,
    (0x0EBB..0x0EBC), :Lao,
    0x0EBD, :Lao,
    (0x0EC0..0x0EC4), :Lao,
    0x0EC6, :Lao,
    (0x0EC8..0x0ECD), :Lao,
    (0x0ED0..0x0ED9), :Lao,
    (0x0EDC..0x0EDD), :Lao,
    0x0F00, :Tibetan,
    (0x0F01..0x0F03), :Tibetan,
    (0x0F04..0x0F12), :Tibetan,
    (0x0F13..0x0F17), :Tibetan,
    (0x0F18..0x0F19), :Tibetan,
    (0x0F1A..0x0F1F), :Tibetan,
    (0x0F20..0x0F29), :Tibetan,
    (0x0F2A..0x0F33), :Tibetan,
    0x0F34, :Tibetan,
    0x0F35, :Tibetan,
    0x0F36, :Tibetan,
    0x0F37, :Tibetan,
    0x0F38, :Tibetan,
    0x0F39, :Tibetan,
    0x0F3A, :Tibetan,
    0x0F3B, :Tibetan,
    0x0F3C, :Tibetan,
    0x0F3D, :Tibetan,
    (0x0F3E..0x0F3F), :Tibetan,
    (0x0F40..0x0F47), :Tibetan,
    (0x0F49..0x0F6C), :Tibetan,
    (0x0F71..0x0F7E), :Tibetan,
    0x0F7F, :Tibetan,
    (0x0F80..0x0F84), :Tibetan,
    0x0F85, :Tibetan,
    (0x0F86..0x0F87), :Tibetan,
    (0x0F88..0x0F8B), :Tibetan,
    (0x0F90..0x0F97), :Tibetan,
    (0x0F99..0x0FBC), :Tibetan,
    (0x0FBE..0x0FC5), :Tibetan,
    0x0FC6, :Tibetan,
    (0x0FC7..0x0FCC), :Tibetan,
    (0x0FCE..0x0FCF), :Tibetan,
    (0x0FD0..0x0FD4), :Tibetan,
    (0x1000..0x102A), :Myanmar,
    (0x102B..0x102C), :Myanmar,
    (0x102D..0x1030), :Myanmar,
    0x1031, :Myanmar,
    (0x1032..0x1037), :Myanmar,
    0x1038, :Myanmar,
    (0x1039..0x103A), :Myanmar,
    (0x103B..0x103C), :Myanmar,
    (0x103D..0x103E), :Myanmar,
    0x103F, :Myanmar,
    (0x1040..0x1049), :Myanmar,
    (0x104A..0x104F), :Myanmar,
    (0x1050..0x1055), :Myanmar,
    (0x1056..0x1057), :Myanmar,
    (0x1058..0x1059), :Myanmar,
    (0x105A..0x105D), :Myanmar,
    (0x105E..0x1060), :Myanmar,
    0x1061, :Myanmar,
    (0x1062..0x1064), :Myanmar,
    (0x1065..0x1066), :Myanmar,
    (0x1067..0x106D), :Myanmar,
    (0x106E..0x1070), :Myanmar,
    (0x1071..0x1074), :Myanmar,
    (0x1075..0x1081), :Myanmar,
    0x1082, :Myanmar,
    (0x1083..0x1084), :Myanmar,
    (0x1085..0x1086), :Myanmar,
    (0x1087..0x108C), :Myanmar,
    0x108D, :Myanmar,
    0x108E, :Myanmar,
    0x108F, :Myanmar,
    (0x1090..0x1099), :Myanmar,
    (0x109E..0x109F), :Myanmar,
    (0x10A0..0x10C5), :Georgian,
    (0x10D0..0x10FA), :Georgian,
    0x10FC, :Georgian,
    (0x2D00..0x2D25), :Georgian,
    (0x1100..0x1159), :Hangul,
    (0x115F..0x11A2), :Hangul,
    (0x11A8..0x11F9), :Hangul,
    (0x3131..0x318E), :Hangul,
    (0x3200..0x321E), :Hangul,
    (0x3260..0x327E), :Hangul,
    (0xAC00..0xD7A3), :Hangul,
    (0xFFA0..0xFFBE), :Hangul,
    (0xFFC2..0xFFC7), :Hangul,
    (0xFFCA..0xFFCF), :Hangul,
    (0xFFD2..0xFFD7), :Hangul,
    (0xFFDA..0xFFDC), :Hangul,
    (0x1200..0x1248), :Ethiopic,
    (0x124A..0x124D), :Ethiopic,
    (0x1250..0x1256), :Ethiopic,
    0x1258, :Ethiopic,
    (0x125A..0x125D), :Ethiopic,
    (0x1260..0x1288), :Ethiopic,
    (0x128A..0x128D), :Ethiopic,
    (0x1290..0x12B0), :Ethiopic,
    (0x12B2..0x12B5), :Ethiopic,
    (0x12B8..0x12BE), :Ethiopic,
    0x12C0, :Ethiopic,
    (0x12C2..0x12C5), :Ethiopic,
    (0x12C8..0x12D6), :Ethiopic,
    (0x12D8..0x1310), :Ethiopic,
    (0x1312..0x1315), :Ethiopic,
    (0x1318..0x135A), :Ethiopic,
    0x135F, :Ethiopic,
    0x1360, :Ethiopic,
    (0x1361..0x1368), :Ethiopic,
    (0x1369..0x137C), :Ethiopic,
    (0x1380..0x138F), :Ethiopic,
    (0x1390..0x1399), :Ethiopic,
    (0x2D80..0x2D96), :Ethiopic,
    (0x2DA0..0x2DA6), :Ethiopic,
    (0x2DA8..0x2DAE), :Ethiopic,
    (0x2DB0..0x2DB6), :Ethiopic,
    (0x2DB8..0x2DBE), :Ethiopic,
    (0x2DC0..0x2DC6), :Ethiopic,
    (0x2DC8..0x2DCE), :Ethiopic,
    (0x2DD0..0x2DD6), :Ethiopic,
    (0x2DD8..0x2DDE), :Ethiopic,
    (0x13A0..0x13F4), :Cherokee,
    (0x1401..0x166C), :Canadian_Aboriginal,
    (0x166D..0x166E), :Canadian_Aboriginal,
    (0x166F..0x1676), :Canadian_Aboriginal,
    0x1680, :Ogham,
    (0x1681..0x169A), :Ogham,
    0x169B, :Ogham,
    0x169C, :Ogham,
    (0x16A0..0x16EA), :Runic,
    (0x16EE..0x16F0), :Runic,
    (0x1780..0x17B3), :Khmer,
    (0x17B4..0x17B5), :Khmer,
    0x17B6, :Khmer,
    (0x17B7..0x17BD), :Khmer,
    (0x17BE..0x17C5), :Khmer,
    0x17C6, :Khmer,
    (0x17C7..0x17C8), :Khmer,
    (0x17C9..0x17D3), :Khmer,
    (0x17D4..0x17D6), :Khmer,
    0x17D7, :Khmer,
    (0x17D8..0x17DA), :Khmer,
    0x17DB, :Khmer,
    0x17DC, :Khmer,
    0x17DD, :Khmer,
    (0x17E0..0x17E9), :Khmer,
    (0x17F0..0x17F9), :Khmer,
    (0x19E0..0x19FF), :Khmer,
    (0x1800..0x1801), :Mongolian,
    0x1804, :Mongolian,
    0x1806, :Mongolian,
    (0x1807..0x180A), :Mongolian,
    (0x180B..0x180D), :Mongolian,
    0x180E, :Mongolian,
    (0x1810..0x1819), :Mongolian,
    (0x1820..0x1842), :Mongolian,
    0x1843, :Mongolian,
    (0x1844..0x1877), :Mongolian,
    (0x1880..0x18A8), :Mongolian,
    0x18A9, :Mongolian,
    0x18AA, :Mongolian,
    (0x3041..0x3096), :Hiragana,
    (0x309D..0x309E), :Hiragana,
    0x309F, :Hiragana,
    (0x30A1..0x30FA), :Katakana,
    (0x30FD..0x30FE), :Katakana,
    0x30FF, :Katakana,
    (0x31F0..0x31FF), :Katakana,
    (0x32D0..0x32FE), :Katakana,
    (0x3300..0x3357), :Katakana,
    (0xFF66..0xFF6F), :Katakana,
    (0xFF71..0xFF9D), :Katakana,
    (0x3105..0x312D), :Bopomofo,
    (0x31A0..0x31B7), :Bopomofo,
    (0x2E80..0x2E99), :Han,
    (0x2E9B..0x2EF3), :Han,
    (0x2F00..0x2FD5), :Han,
    0x3005, :Han,
    0x3007, :Han,
    (0x3021..0x3029), :Han,
    (0x3038..0x303A), :Han,
    0x303B, :Han,
    (0x3400..0x4DB5), :Han,
    (0x4E00..0x9FC3), :Han,
    (0xF900..0xFA2D), :Han,
    (0xFA30..0xFA6A), :Han,
    (0xFA70..0xFAD9), :Han,
    (0x20000..0x2A6D6), :Han,
    (0x2F800..0x2FA1D), :Han,
    (0xA000..0xA014), :Yi,
    0xA015, :Yi,
    (0xA016..0xA48C), :Yi,
    (0xA490..0xA4C6), :Yi,
    (0x10300..0x1031E), :Old_Italic,
    (0x10320..0x10323), :Old_Italic,
    (0x10330..0x10340), :Gothic,
    0x10341, :Gothic,
    (0x10342..0x10349), :Gothic,
    0x1034A, :Gothic,
    (0x10400..0x1044F), :Deseret,
    (0x0300..0x036F), :Inherited,
    (0x064B..0x0655), :Inherited,
    0x0670, :Inherited,
    (0x0951..0x0952), :Inherited,
    (0x1DC0..0x1DE6), :Inherited,
    (0x1DFE..0x1DFF), :Inherited,
    (0x200C..0x200D), :Inherited,
    (0x20D0..0x20DC), :Inherited,
    (0x20DD..0x20E0), :Inherited,
    0x20E1, :Inherited,
    (0x20E2..0x20E4), :Inherited,
    (0x20E5..0x20F0), :Inherited,
    (0x302A..0x302F), :Inherited,
    (0x3099..0x309A), :Inherited,
    (0xFE00..0xFE0F), :Inherited,
    (0xFE20..0xFE26), :Inherited,
    0x101FD, :Inherited,
    (0x1D167..0x1D169), :Inherited,
    (0x1D17B..0x1D182), :Inherited,
    (0x1D185..0x1D18B), :Inherited,
    (0x1D1AA..0x1D1AD), :Inherited,
    (0xE0100..0xE01EF), :Inherited,
    (0x1700..0x170C), :Tagalog,
    (0x170E..0x1711), :Tagalog,
    (0x1712..0x1714), :Tagalog,
    (0x1720..0x1731), :Hanunoo,
    (0x1732..0x1734), :Hanunoo,
    (0x1740..0x1751), :Buhid,
    (0x1752..0x1753), :Buhid,
    (0x1760..0x176C), :Tagbanwa,
    (0x176E..0x1770), :Tagbanwa,
    (0x1772..0x1773), :Tagbanwa,
    (0x1900..0x191C), :Limbu,
    (0x1920..0x1922), :Limbu,
    (0x1923..0x1926), :Limbu,
    (0x1927..0x1928), :Limbu,
    (0x1929..0x192B), :Limbu,
    (0x1930..0x1931), :Limbu,
    0x1932, :Limbu,
    (0x1933..0x1938), :Limbu,
    (0x1939..0x193B), :Limbu,
    0x1940, :Limbu,
    (0x1944..0x1945), :Limbu,
    (0x1946..0x194F), :Limbu,
    (0x1950..0x196D), :Tai_Le,
    (0x1970..0x1974), :Tai_Le,
    (0x10000..0x1000B), :Linear_B,
    (0x1000D..0x10026), :Linear_B,
    (0x10028..0x1003A), :Linear_B,
    (0x1003C..0x1003D), :Linear_B,
    (0x1003F..0x1004D), :Linear_B,
    (0x10050..0x1005D), :Linear_B,
    (0x10080..0x100FA), :Linear_B,
    (0x10380..0x1039D), :Ugaritic,
    0x1039F, :Ugaritic,
    (0x10450..0x1047F), :Shavian,
    (0x10480..0x1049D), :Osmanya,
    (0x104A0..0x104A9), :Osmanya,
    (0x10800..0x10805), :Cypriot,
    0x10808, :Cypriot,
    (0x1080A..0x10835), :Cypriot,
    (0x10837..0x10838), :Cypriot,
    0x1083C, :Cypriot,
    0x1083F, :Cypriot,
    (0x2800..0x28FF), :Braille,
    (0x1A00..0x1A16), :Buginese,
    (0x1A17..0x1A18), :Buginese,
    (0x1A19..0x1A1B), :Buginese,
    (0x1A1E..0x1A1F), :Buginese,
    (0x03E2..0x03EF), :Coptic,
    (0x2C80..0x2CE4), :Coptic,
    (0x2CE5..0x2CEA), :Coptic,
    (0x2CF9..0x2CFC), :Coptic,
    0x2CFD, :Coptic,
    (0x2CFE..0x2CFF), :Coptic,
    (0x1980..0x19A9), :New_Tai_Lue,
    (0x19B0..0x19C0), :New_Tai_Lue,
    (0x19C1..0x19C7), :New_Tai_Lue,
    (0x19C8..0x19C9), :New_Tai_Lue,
    (0x19D0..0x19D9), :New_Tai_Lue,
    (0x19DE..0x19DF), :New_Tai_Lue,
    (0x2C00..0x2C2E), :Glagolitic,
    (0x2C30..0x2C5E), :Glagolitic,
    (0x2D30..0x2D65), :Tifinagh,
    0x2D6F, :Tifinagh,
    (0xA800..0xA801), :Syloti_Nagri,
    0xA802, :Syloti_Nagri,
    (0xA803..0xA805), :Syloti_Nagri,
    0xA806, :Syloti_Nagri,
    (0xA807..0xA80A), :Syloti_Nagri,
    0xA80B, :Syloti_Nagri,
    (0xA80C..0xA822), :Syloti_Nagri,
    (0xA823..0xA824), :Syloti_Nagri,
    (0xA825..0xA826), :Syloti_Nagri,
    0xA827, :Syloti_Nagri,
    (0xA828..0xA82B), :Syloti_Nagri,
    (0x103A0..0x103C3), :Old_Persian,
    (0x103C8..0x103CF), :Old_Persian,
    0x103D0, :Old_Persian,
    (0x103D1..0x103D5), :Old_Persian,
    0x10A00, :Kharoshthi,
    (0x10A01..0x10A03), :Kharoshthi,
    (0x10A05..0x10A06), :Kharoshthi,
    (0x10A0C..0x10A0F), :Kharoshthi,
    (0x10A10..0x10A13), :Kharoshthi,
    (0x10A15..0x10A17), :Kharoshthi,
    (0x10A19..0x10A33), :Kharoshthi,
    (0x10A38..0x10A3A), :Kharoshthi,
    0x10A3F, :Kharoshthi,
    (0x10A40..0x10A47), :Kharoshthi,
    (0x10A50..0x10A58), :Kharoshthi,
    (0x1B00..0x1B03), :Balinese,
    0x1B04, :Balinese,
    (0x1B05..0x1B33), :Balinese,
    0x1B34, :Balinese,
    0x1B35, :Balinese,
    (0x1B36..0x1B3A), :Balinese,
    0x1B3B, :Balinese,
    0x1B3C, :Balinese,
    (0x1B3D..0x1B41), :Balinese,
    0x1B42, :Balinese,
    (0x1B43..0x1B44), :Balinese,
    (0x1B45..0x1B4B), :Balinese,
    (0x1B50..0x1B59), :Balinese,
    (0x1B5A..0x1B60), :Balinese,
    (0x1B61..0x1B6A), :Balinese,
    (0x1B6B..0x1B73), :Balinese,
    (0x1B74..0x1B7C), :Balinese,
    (0x12000..0x1236E), :Cuneiform,
    (0x12400..0x12462), :Cuneiform,
    (0x12470..0x12473), :Cuneiform,
    (0x10900..0x10915), :Phoenician,
    (0x10916..0x10919), :Phoenician,
    0x1091F, :Phoenician,
    (0xA840..0xA873), :Phags_Pa,
    (0xA874..0xA877), :Phags_Pa,
    (0x07C0..0x07C9), :Nko,
    (0x07CA..0x07EA), :Nko,
    (0x07EB..0x07F3), :Nko,
    (0x07F4..0x07F5), :Nko,
    0x07F6, :Nko,
    (0x07F7..0x07F9), :Nko,
    0x07FA, :Nko,
    (0x1B80..0x1B81), :Sundanese,
    0x1B82, :Sundanese,
    (0x1B83..0x1BA0), :Sundanese,
    0x1BA1, :Sundanese,
    (0x1BA2..0x1BA5), :Sundanese,
    (0x1BA6..0x1BA7), :Sundanese,
    (0x1BA8..0x1BA9), :Sundanese,
    0x1BAA, :Sundanese,
    (0x1BAE..0x1BAF), :Sundanese,
    (0x1BB0..0x1BB9), :Sundanese,
    (0x1C00..0x1C23), :Lepcha,
    (0x1C24..0x1C2B), :Lepcha,
    (0x1C2C..0x1C33), :Lepcha,
    (0x1C34..0x1C35), :Lepcha,
    (0x1C36..0x1C37), :Lepcha,
    (0x1C3B..0x1C3F), :Lepcha,
    (0x1C40..0x1C49), :Lepcha,
    (0x1C4D..0x1C4F), :Lepcha,
    (0x1C50..0x1C59), :Ol_Chiki,
    (0x1C5A..0x1C77), :Ol_Chiki,
    (0x1C78..0x1C7D), :Ol_Chiki,
    (0x1C7E..0x1C7F), :Ol_Chiki,
    (0xA500..0xA60B), :Vai,
    0xA60C, :Vai,
    (0xA60D..0xA60F), :Vai,
    (0xA610..0xA61F), :Vai,
    (0xA620..0xA629), :Vai,
    (0xA62A..0xA62B), :Vai,
    (0xA880..0xA881), :Saurashtra,
    (0xA882..0xA8B3), :Saurashtra,
    (0xA8B4..0xA8C3), :Saurashtra,
    0xA8C4, :Saurashtra,
    (0xA8CE..0xA8CF), :Saurashtra,
    (0xA8D0..0xA8D9), :Saurashtra,
    (0xA900..0xA909), :Kayah_Li,
    (0xA90A..0xA925), :Kayah_Li,
    (0xA926..0xA92D), :Kayah_Li,
    (0xA92E..0xA92F), :Kayah_Li,
    (0xA930..0xA946), :Rejang,
    (0xA947..0xA951), :Rejang,
    (0xA952..0xA953), :Rejang,
    0xA95F, :Rejang,
    (0x10280..0x1029C), :Lycian,
    (0x102A0..0x102D0), :Carian,
    (0x10920..0x10939), :Lydian,
    0x1093F, :Lydian,
    (0xAA00..0xAA28), :Cham,
    (0xAA29..0xAA2E), :Cham,
    (0xAA2F..0xAA30), :Cham,
    (0xAA31..0xAA32), :Cham,
    (0xAA33..0xAA34), :Cham,
    (0xAA35..0xAA36), :Cham,
    (0xAA40..0xAA42), :Cham,
    0xAA43, :Cham,
    (0xAA44..0xAA4B), :Cham,
    0xAA4C, :Cham,
    0xAA4D, :Cham,
    (0xAA50..0xAA59), :Cham,
    (0xAA5C..0xAA5F), :Cham,
    :Unknown
  )
)
