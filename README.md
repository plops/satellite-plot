
# spectral reflectance data

- from https://s5phub.copernicus.eu
-  h5dump -n S5P_OFFL_L1B_RA_BD8_20180630T181331_20180630T195501_03694_01_010000_20180630T214541.nc

```
 dataset    /BAND8_RADIANCE/STANDARD_MODE/OBSERVATIONS/radiance
```

- h5dump -H S5P_OFFL_L1B_RA_BD8_20180630T181331_20180630T195501_03694_01_010000_20180630T214541.nc

```
DATASET "radiance" {
               DATATYPE  H5T_IEEE_F32LE
               DATASPACE  SIMPLE { ( 1, 3245, 215, 480 ) / ( 1, 3245, 215, 480 ) }
               ATTRIBUTE "DIMENSION_LIST" {
                  DATATYPE  H5T_VLEN { H5T_REFERENCE { H5T_STD_REF_OBJECT }}
                  DATASPACE  SIMPLE { ( 4 ) / ( 4 ) }
               }
               ATTRIBUTE "_FillValue" {
                  DATATYPE  H5T_IEEE_F32LE
                  DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
               }
               ATTRIBUTE "ancilary_vars" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 89;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "comment" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 50;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "coordinates" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 94;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "detector_column_offset" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 1;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "detector_row_offset" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 2;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "long_name" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 24;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
               ATTRIBUTE "units" {
                  DATATYPE  H5T_STRING {
                     STRSIZE 21;
                     STRPAD H5T_STR_NULLTERM;
                     CSET H5T_CSET_ASCII;
                     CTYPE H5T_C_S1;
                  }
                  DATASPACE  SCALAR
               }
            }
```


# get power production data
- from https://www.energy-charts.de


# get radar data

https://en.wikipedia.org/wiki/Sentinel-1
Sentinel-1 will provide continuity of data from the ERS and Envisat missions

-    Raw Level 0 data
-    Processed Level 1 Single Look Complex (SLC) data:
        Complex images with phase and amplitude of specified areas
-    Ground Range Detected (GRD) Level 1 data:
        Only systematically distributed multi-looked intensity
-    Level 2 Ocean (OCN) data:
        Systematically distributed data of ocean's geophysical parameters

2015 they wrote:

```
The Sentinel-1 Scientific Data Hub provides free and open access to a
Rolling Archive of Sentinel-1 Level-0 and Level-1 user products.

The S-1 Scientific data Hub Rolling Archive maintains the latest 2
months of products for download via HTTP.  The target of the 2 months
rolling archive will be reached in progression starting from a rolling
period of 2 weeks commencing on the 3rd of October.
```

I think I am more interested in this:

```
The Copernicus Open Access Hub (previously known as Sentinels
Scientific Data Hub) provides complete, free and open access to
Sentinel-1, Sentinel-2 and Sentinel-3 user products, starting from the
In-Orbit Commissioning Review (IOCR).
```

Open Access hub for interactive GUI
(only recent months, within 24hours of acquisition)
API hub for data download https://scihub.copernicus.eu/apihub/search
https://sentinel.esa.int/documents/247904/1877131/Sentinel-1-Product-Definition

alternatively data can be obtained from DAAC:
https://www.asf.alaska.edu/sentinel/
(complete historic archive of processed files, within 3 days of acquisition)

Precision State Vector (orbits) within 20 days after data acquisition.



- They have a Copernicus Sentinel App for Android and iOS, it has good
  ratings
- Sentinel-1 is a constallation of 2 Satellites orbiting 180deg apart. Imaging earth every six days
- same image every 12 days
- resolution is 2-4m https://sentinel.esa.int/web/sentinel/user-guides/sentinel-1-sar/resolutions/level-1-single-look-complex
- radar carrier 5.405GHz 4.141kW peak power
- pulse repition 1kHz - 3kHz
- instrument duty cycle 25min per orbit

- esa echoes in space - land: crop type mapping with sentinel-1
- youtube eo college contains course material
- software http://step.esa.int/main/download/

- 6cm rf waves interact are scattered back by surface waves on ocean if bragg condition is met (usually at 1-2m/s wind)
- illumination angle affects detected ocean surface wave period
- longer surface waves (10s of meters) modulate bragg signal
- not all data can be sent back, cat claw pattern to get general idea of ocean conditions
- ship tracking would require to capture large amounts of data

- ocean virtual laboratory allows zooming into 20x20 km images with wave patterns https://ovl.oceandatalab.com
- behind french polynesian islands different wave patterns due to diffraction
- waves can travel in marginal sea ice zone

- python code for sar processing
https://github.com/senbox-org/snap-engine/tree/master/snap-python/src/main/resources/snappy/examples
https://senbox.atlassian.net/wiki/spaces/SNAP/pages/19300362/How+to+use+the+SNAP+API+from+Python
https://github.com/senbox-org/snap-examples
https://github.com/johntruckenbrodt/pyroSAR

- SEAScope SA is the next generation synergy analysis standalone tool.
Today only available for Linux and working with local datasets, it
allows an even more fluid visualization experience, and more
interaction and manipulation of the datasets thanks to an extensive
use of the GPU and the two way communication with iPython notebooks

https://seascope.oceandatalab.com/

https://www.oceandatalab.com/8369d04b-9c25-4489-b3ca-70b96b30e42a


- raw sar data description
https://earth.esa.int/c/document_library/get_file?folderId=349449&name=DLFE-4502.pdf