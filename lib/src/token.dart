enum TokenType {
  // Constants
  nan,
  pinf,
  ninf,
  pi,
  deg2rad,
  rad2deg,
  epsilon,

  // Arithmic
  abs,
  acos,
  add,
  and,
  asin,
  atan,
  atan2,
  ceil,
  cos,
  div,
  exp,
  floor,
  log,
  max,
  min,
  mod,
  mul,
  nor,
  not,
  sin,

  // Jumping execution
  branch,
  branchRelative,
  jump,
  jumpRelative,
  al, // set return address

  // Conditional tokens
  ap, // Approximately
  apz,
  dns,
  dse,
  eq,
  eqz,
  ge,
  gez,
  gt,
  gtz,
  le,
  lez,
  lt,
  ltz,
  na, // Not approximately
  naz,
  ne,
  nez,

  // Load values
  load,
  loadBatch,
  loadBatchSlot,
  loadBatchNamed,
  loadBatchNamedSlot,
  loadReagent,
  loadSlot,

  // Store values
  store,
  storeBatch,
  storeBatchSlot,
  storeBatchNamed,
  storerBatchNamedSlot,

  // Stack operators
  peek,
  pop,
  push,

  //  misc
  hcf, // Halt and catch fire
  move, // Move to register
  rand,
  round,
  select,
  hashString,
  sleep,
  quote, // " used only in HASH("..")
  number,

  // Parser Tokens
  error,
  eof,
}

class Token {
  final TokenType type;
  late String literal;
  final int line;
  final int position;

  Token(this.type, this.literal, this.line,  this.position);
}