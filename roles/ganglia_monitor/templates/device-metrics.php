<?php
// adopted from http://nousefor.net/79/2012/04/php/ganglia-iostat-disk-metrics/
// {{ ansible_managed }}

exec('iostat -d -x -k 10 2', $out);

$out = array_slice($out, ceil(count($out) / 2));
$header = array();
$data = array();

foreach ($out as $line) {
    $line = preg_replace('/\s+/', ' ', $line);
    $cols = explode(" ", $line);

    if ($cols[0] == "Device:") {
        $header = $cols;
    } elseif (count($header) > 0 && count($cols) > 1) {
        $data[] = $cols;
    }
}

$titles = array();
$titles['rrqm_s'] = 'Merged Reads';
$titles['wrqm_s'] = 'Merged Writes';
$titles['r_s'] = 'Completed Reads';
$titles['w_s'] = 'Completed Writes';
$titles['rkB_s'] = 'Data Read';
$titles['wkB_s'] = 'Data Written';
$titles['avgrq-sz'] = 'Average Req Size';
$titles['avgqu-sz'] = 'Average Req Queue Length';
$titles['await'] = 'Await';
$titles['r_await'] = 'Average Read Await';
$titles['w_await'] = 'Average Write Await';
$titles['util'] = 'CPU Time';

$units = array();
$units['rrqm_s'] = 'queued reqs/sec';
$units['wrqm_s'] = 'queued reqs/sec';
$units['r_s'] = 'reqs/sec';
$units['w_s'] = 'reqs/sec';
$units['rkB_s'] = 'kB/sec';
$units['wkB_s'] = 'kB/sec';
$units['avgrq-sz'] = 'sectors';
$units['avgqu-sz'] = 'sectors';
$units['await'] = 'ms';
$units['r_await'] = 'ms';
$units['w_await'] = 'ms';
$units['util'] = '%';

for ($col = 0; $col < count($header); $col++) {
    $header[$col] = str_replace("/", "_", $header[$col]);
    $header[$col] = str_replace("%", "", $header[$col]);
}

for ($row = 0; $row < count($data); $row++) {
    $namePrefix = "dev_" . $data[$row][0] . "-";
    $titlePrefix = "dev/" . $data[$row][0] . " ";

    for ($col = 1; $col < count($header); $col++) {
        if ($header[$col] == 'svctm')
            continue;

        if ($header[$col] == '')
            continue;

        if (!isset($data[$row][$col]))
            continue;

        $name = $namePrefix . $header[$col];
        $title = $titlePrefix . $titles[$header[$col]];
        $value = $data[$row][$col];
        $unit = $units[$header[$col]];

        exec('gmetric -c /etc/ganglia/gmond.conf --name="' . $name . '" --title="' . $title . '" --value="' . $value . '" --type="float" --units="' . $unit . '" -g disk');
    }

    exec('/usr/sbin/hddtemp -q -n /dev/' . $data[$row][0], $temperature);
    exec('gmetric -c /etc/ganglia/gmond.conf --name="' . $namePrefix . 'temp" --title="' . $titlePrefix . 'Temperature" --value="' . $temperature[0] . '" --type="int8" --units="degrees C" -g disk');
}
?>