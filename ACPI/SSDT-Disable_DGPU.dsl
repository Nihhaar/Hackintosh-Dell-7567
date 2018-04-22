/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180313 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLTo9kbD.aml, Sun Apr 22 17:38:49 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000092 (146)
 *     Revision         0x02
 *     Checksum         0x39
 *     OEM ID           "hack"
 *     OEM Table ID     "D-DGPU"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20161117 (538317079)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "D-DGPU", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)    // 0 Arguments (from opcode)

    Device (RMD1)
    {
        Name (_HID, "RMD10000")  // _HID: Hardware ID
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))
            {
                \_SB.PCI0.PEG0.PEGP._OFF ()
            }
        }
    }
}

