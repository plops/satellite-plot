
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