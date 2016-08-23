To map/plot all data from all EcoMapper missions, use
map_all.m / plot_all.m

To map/plot one type of data from all EcoMapper missions, use 
map_data_from_ecomapper_by_type / plot_em_by_type

To map/plot one type of data for one day of EM missions, 
EITHER 
use map_data_from_ecomapper_by_type_and_date / plot_em_type_date
or
use map_data_from_ecomapper_by_type / plot_em_by_type / map_all / plot_all (?)
and change the data_prefix_path to the specific folder


# the following you can do with above functions, choosing
# 'water_depth' or 'water_depth_dvl' as type
##To map bathymetry from EcoMapper log file, see:
##* map_bathymetry_from_ecomapper.m
##* map_interpolated_bathymetry_from_ecomapper.m
##(these functions may call compile_all_bathy.m)

