import std.stdio, std.file;

uint MAX_PROG_LEN = 30000;


void interpret(string program) {
  // prepare VM
  ubyte[3000] data;   // hmm,,,
  uint data_ptr = 0;
  uint loop_depth = 0;
    
  // execution loop
  for (int instruction_ptr; instruction_ptr < program.length; ++instruction_ptr) {
    switch (program[instruction_ptr]) {
    case '>': data_ptr++; break;
    case '<': data_ptr--; break;
    case '+': data[data_ptr]++; break;
    case '-': data[data_ptr]--; break;
    case '.': {
      write(cast(char) data[data_ptr]);
      break;
    }
    case ',': {  // looks ugly...
      char[] buf;
      stdin.readln(buf);
      data[data_ptr] = cast(ubyte) buf[0];
      break;
    }
    case '[': {
      if (data[data_ptr] == 0) {
	instruction_ptr++;
	while (loop_depth > 0 || program[instruction_ptr] != ']') {
	  if (program[instruction_ptr] == '[') {
	    loop_depth++;
	  } else if (program[instruction_ptr] == ']') {
	    loop_depth--;
	  }
	  instruction_ptr++;
	} 
      }
      break;
    }
    case ']': {
      instruction_ptr--;
      while (loop_depth >0 || program[instruction_ptr] != '[') {
	if (program[instruction_ptr] == ']') {
	  loop_depth++;
	} else if (program[instruction_ptr] == '[') {
	  loop_depth--;
	}
	instruction_ptr--;
      }
      instruction_ptr--;
      break;
    }
    default: break;
    }
  }
}


void main(string[] args) {
  if (args.length < 2) {
    writeln("no file given.");
    return;
  }

  auto program = cast(string) read(args[1], MAX_PROG_LEN);
  interpret(program);
  writeln();
}