/*
 *
 *	PCI defines and function prototypes
 *	Copyright 1994, Drew Eckhardt
 *	Copyright 1997, 1998 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
 *
 *	For more information, please consult the following manuals (look at
 *	http://www.pcisig.com/ for how to get them):
 *
 *	PCI BIOS Specification
 *	PCI Local Bus Specification
 *	PCI to PCI Bridge Specification
 *	PCI System Design Guide
 *
 * $Id$
 */

#ifndef BSP_POWERPC_PCI_H
#define BSP_POWERPC_PCI_H

#include <rtems/pci.h>

struct _pin_routes
{
      int pin, int_name[4];
};
struct _int_map
{
      int bus, slot, opts;
      struct _pin_routes pin_route[5];
};

void FixupPCI( const struct _int_map *, int (*swizzler)(int,int) );

/* scan for a specific device */
/* find a particular PCI device
 * (currently, only bus0 is scanned for device/fun0)
 *
 * RETURNS: zero on success, bus/dev/fun in *pbus / *pdev / *pfun
 */
int
BSP_pciFindDevice(unsigned short vendorid, unsigned short deviceid,
                int instance, int *pbus, int *pdev, int *pfun);

#endif /* BSP_POWERPC_PCI_H */
