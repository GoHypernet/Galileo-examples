# ---------------------------------------------------------------------------
# calroad_merge_test.py
# Created on: 3/27/2019
# By: Michael A. Carson
# Description: Unzips California roads shapefiles and merges them together.
# Dependencies: Requires python OGR module from GDAL.  Also data and results directories at same level as this script.
# ---------------------------------------------------------------------------

# Import modules
import time
import os
import zipfile
import ogr

# Display start time
start_time = time.time()
print ("Start time: {}".format(time.strftime("%m/%d/%Y %H:%M:%S", time.localtime(start_time))))

# Setup variables
scriptdir = os.path.dirname(os.path.realpath(__file__))
datadir = os.path.join(scriptdir, "data")
resdir = os.path.join(scriptdir, "results")
outshape = os.path.join(resdir, "calroadstest.shp")

# Read in zip files and unzip to results directory
files = [f for f in os.listdir(datadir) if f.endswith(".zip")]
for i in files:
  zipf = os.path.join(datadir, i)
  print("Unzipping {}...".format(zipf))
  zipr = zipfile.ZipFile(zipf, 'r')
  zipr.extractall(resdir)
  zipr.close()

# Merge shapefiles
geomtype = ogr.wkbLineString
out_driver = ogr.GetDriverByName("ESRI Shapefile")
if os.path.exists(outshape):
  out_driver.DeleteDataSource(outshape)
out_ds = out_driver.CreateDataSource(outshape)
out_layer = out_ds.CreateLayer(outshape, geom_type=geomtype)
files = [f for f in os.listdir(resdir) if f.endswith("_roads.shp")]
for i in files:
  shpf = os.path.join(resdir, i)
  print("Merging {}...".format(shpf))
  ds = ogr.Open(shpf)
  lyr = ds.GetLayer()
  for feat in lyr:
    out_feat = ogr.Feature(out_layer.GetLayerDefn())
    out_feat.SetGeometry(feat.GetGeometryRef().Clone())
    out_layer.CreateFeature(out_feat)
    out_feat = None
    out_layer.SyncToDisk()

# Display end time
end_time = time.time()
diff = end_time - start_time
timetype = "sec"
if diff > 60:
  diff = diff / 60
  timetype = "min"
  if diff > 60:
    diff = diff / 60
    timetype = "hrs"
print ("End time: {} Run: {} {}".format(time.strftime("%m/%d/%Y %H:%M:%S", time.localtime(end_time)), round(diff, 2), timetype))
