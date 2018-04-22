/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180313 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLo3P7XG.aml, Sun Apr 22 17:38:21 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000004A (74)
 *     Revision         0x02
 *     Checksum         0xE8
 *     OEM ID           "hack"
 *     OEM Table ID     "D-PRW"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20161210 (538317328)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "D-PRW", 0x00000000)
{
    External (XPRW, MethodObj)    // 2 Arguments (from opcode)

    Method (GPRW, 2, NotSerialized)
    {
        If (LEqual (0x6D, Arg0))
        {
            Return (Package (0x02)
            {
                0x6D, 
                Zero
            })
        }

        Return (XPRW (Arg0, Arg1))
    }
}

