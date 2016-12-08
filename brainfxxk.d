import std.stdio, std.file;

static immutable uint MAX_PROGRAM_LENGTH = 3000;

void interpret(string code)
{
    auto pc = code.ptr;  // pointer to current instruction.
    char[MAX_PROGRAM_LENGTH] data = void;  // zero-initialized,thanks by dmd!
    auto ptr = data.ptr;  // pointer to curent data position.
    int depth;  // Loop depth.

    auto start = pc;
LOOP:
    if ((pc - start) >= code.length)
        return;
    switch (*pc)
    {
    case '>':
        ptr++;
        pc++;
        goto LOOP;
    case '<':
        ptr--;
        pc++;
        goto LOOP;
    case '+':
        *ptr += 1;
        pc++;
        goto LOOP;
    case '-':
        *ptr -= 1;
        pc++;
        goto LOOP;
    case '.':
        write(*ptr);
        pc++;
        goto LOOP;
    case ',':
        char[] buf;
        stdin.readln(buf);
        *ptr = cast(char) buf[0];
        pc++;
        goto LOOP;
    case '[':
        if (*ptr == 0)
        {
            pc++;
            while (depth > 0 || *pc != ']')
            {
                if (*pc == '[') depth++;
                else if (*pc == ']') depth--;
                pc++;
            }
        }
        pc++;
        goto LOOP;
    case ']':
        pc--;
        while (depth > 0 || *pc != '[')
        {
            if (*pc == ']') depth++;
            else if (*pc == '[') depth--;
            pc--;
        }
        goto LOOP;
    default:
        assert(0);
    }
}

void main(string[] args)
{
    if (args.length < 2)
    {
        writeln("no file given.");
        return;
    }
    auto program = cast(string) read(args[1], MAX_PROGRAM_LENGTH);
    interpret(program);
    writeln();
}
