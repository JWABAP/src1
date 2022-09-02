@AbapCatalog.sqlViewAppendName: 'ZC115EXT0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extend'
extend view ZC115CDS0003 with ZC115EXT0003 
{
    ztc1150002.zzsaknr,
    ztc1150002.zzkostl,
    ztc1150002.zzshkzg,
    ztc1150002.zzlgort
}
