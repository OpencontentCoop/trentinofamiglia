<?php

class TrentinoFamigliaMapsRepositoryCache
{
    public static function clearCache()
    {
        $repository = new MapsCacheManager();
        $repository->clearAllCache();
    }
}
