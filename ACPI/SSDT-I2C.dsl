/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLHSpvkq.aml, Tue Dec  4 05:04:39 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000019C (412)
 *     Revision         0x02
 *     Checksum         0x9D
 *     OEM ID           "syscl"
 *     OEM Table ID     "I2C"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "syscl", "I2C", 0x00000000)
{
    External (_SB_.PCI0.GPI0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.I2C1.TPD1, DeviceObj)    // (from opcode)

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
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x001B
                    }
            })
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }

    Name (_SB.PCI0.LPCB.PS2K.RMCF, Package (0x08)
    {
        "Mouse", 
        Package (0x02)
        {
            "DisableDevice", 
            ">y"
        }, 

        "Synaptics TouchPad", 
        Package (0x02)
        {
            "DisableDevice", 
            ">y"
        }, 

        "ALPS GlidePoint", 
        Package (0x02)
        {
            "DisableDevice", 
            ">y"
        }, 

        "Sentelic FSP", 
        Package (0x02)
        {
            "DisableDevice", 
            ">y"
        }
    })
}

