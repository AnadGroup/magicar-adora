class MapUtils {

 /* static String getTileNumber(final double lat, final double lon, final int zoom) {
    int xtile = math.floor( (lon + 180) / 360 * (1<<zoom) ) ;
    int ytile = (int)Math.floor( (1 - Math.log(Math.tan(Math.toRadians(lat)) + 1 / Math.cos(Math.toRadians(lat))) / Math.PI) / 2 * (1<<zoom) ) ;
    if (xtile < 0)
      xtile=0;
    if (xtile >= (1<<zoom))
      xtile=((1<<zoom)-1);
    if (ytile < 0)
      ytile=0;
    if (ytile >= (1<<zoom))
      ytile=((1<<zoom)-1);
    return("" + zoom.toString() + "/" + xtile.toString() + "/" + ytile.toString());
  }
}*/
}
