package com.example.your_project_name;

import android.os.Environment;
import android.os.StatFs;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class DeviceStorageManager {
    // A constant for converting bytes to gigabytes.
    private static final double BYTES_IN_GB = 1024.0 * 1024.0 * 1024.0;

    public Map<String, Double> getStorageInfo() {
        File path = Environment.getDataDirectory();
        StatFs stat = new StatFs(path.getPath());

        long blockSize = stat.getBlockSizeLong();
        long totalBlocks = stat.getBlockCountLong();
        long availableBlocks = stat.getAvailableBlocksLong();

        double totalSpace = totalBlocks * blockSize / BYTES_IN_GB;
        double freeSpace = availableBlocks * blockSize / BYTES_IN_GB;

        Map<String, Double> storageInfo = new HashMap<>();
        storageInfo.put("totalSpace", totalSpace);
        storageInfo.put("freeSpace", freeSpace);

        return storageInfo;
    }
}