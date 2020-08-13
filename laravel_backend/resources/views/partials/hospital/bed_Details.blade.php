<table class="table table-bordered table-info" id="details">
    <tbody>
    <tr>
        <td>Total</td>
        <td id="total" class="values">{{isset($data->total) ? $data->total : 0}}</td>
    </tr>
    <tr>
        <td>Occupied</td>
        <td id="occupied" class="values">{{isset($data->occupied) ? $data->occupied : 0}}</td>
    </tr>
{{--    <tr>--}}
{{--        <td colspan="2"></td>--}}
{{--    </tr>--}}
    <tr>
        <td style="border-right: none;">Available</td>
        <td id="available" style="border-left: none"><strong>{{isset($data->available) ? $data->available : 0}}</strong></td>
    </tr>
    </tbody>
</table>
