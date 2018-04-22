/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180313 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLt3vfUn.aml, Sun Apr 22 17:38:01 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000061 (97)
 *     Revision         0x02
 *     Checksum         0xF0
 *     OEM ID           "hack"
 *     OEM Table ID     "PluginTy"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20161210 (538317328)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "PluginTy", 0x00000000)
{
    External (_PR_.CPU0, DeviceObj)    // (from opcode)

    Method (\_PR.CPU0._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LNot (Arg2))
        {
            Return (Buffer (One)
            {
                 0x03                                           
            })
        }

        Return (Package (0x02)
        {
            "plugin-type", 
            One
        })
    }
}

