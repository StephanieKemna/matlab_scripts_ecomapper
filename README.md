# matlab_scripts_ecomapper

This repo contains scripts I wrote for processing .log files
coming from our EcoMapper AUV (which is basically an Iver2).
These have last been tested and adapted for Matlab R2018a pre-release.

## plotting all data from several missions
To map/plot all data from all EcoMapper missions, use
`map_all.m` / `plot_all.m`
which will collect data from all missions in the specified folder, 
and plot 2D and 3D figures (plot_all) or a top-down view (map_all).
E.g. to plot all sensor data from one day at the Puddingstone reservoir:
```
plot_all('~/data_em/puddingstone_20180419');
map_all('~/data_em/puddingstone_20180419');
```

## plotting a single sensor from several missions 
To map/plot one type of data from all EcoMapper missions, use 
`map_data_from_ecomapper_by_type` / `plot_em_by_type`
E.g. to plot only Chlorophyll data from one day at Puddingstone:
```
plot_em_by_type('chl','~/data_em/puddingstone_20180419')
```

## plotting all data for a single mission
To map/plot one type of data for one day of EM missions, 
EITHER use `map_data_from_ecomapper_by_type_and_date` / `plot_em_type_date`
or use `map_data_from_ecomapper_by_type` / `plot_em_by_type` / `map_all` / `plot_all`
and change the data_prefix_path to the specific log file.
(Haven't tested this in a while.. :) )

