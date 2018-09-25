/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180313 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLr36CnH.aml, Sun Apr 22 17:38:40 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000D4 (212)
 *     Revision         0x02
 *     Checksum         0x44
 *     OEM ID           "syscl"
 *     OEM Table ID     "I2C"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20161210 (538317328)
 */
DefinitionBlock ("", "SSDT", 2, "syscl", "I2C", 0x00000000)
{
    External (_SB_.PCI0.GPI0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.TPD1, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.TPD1.SBFB, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.TPD1.SBFG, FieldUnitObj)    // (from opcode)
    External (SBFB, UnknownObj)    // (from opcode)
    External (SBFG, UnknownObj)    // (from opcode)

    Scope (_SB.PCI0.GPI0)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }
    }

    Scope (_SB.PCI0.I2C1.TPD1)
    {
        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }

    // Disable any VoodooPS2Trackpad and VoodooPS2Mouse devices from loading
    Name(_SB.PCI0.LPCB.PS2K.RMCF, Package()
    {
        "Mouse", Package()
        {
            "DisableDevice", ">y",
        },
        "Synaptics TouchPad", Package()
        {
            "DisableDevice", ">y",
        },
        "ALPS GlidePoint", Package()
        {
            "DisableDevice", ">y",
        },
        "Sentelic FSP", Package()
        {
            "DisableDevice", ">y",
        },
    })
}

