@extends('layouts.app')
@section('content')
<div class="container">
    @if(session()->has('error'))
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error!</strong> {{session()->pull('error')}}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    @elseif(session()->has('success'))
        <div class="alert alert-primary alert-dismissible fade show" role="alert">
            <strong>Success!</strong> {{session()->pull('success')}}
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    @endif
    <div class="d-flex">
        <div class="categories col-md-3">
            <div class="heading text-center">
                <u class="text-uppercase">Bed Categories</u>
            </div>
            @include('partials.hospital.bed_categories')
        </div>
        <div class="details col-md-9">
            <div class="heading text-center">
                <u class="text-uppercase">Bed Details</u>
            </div>
            @include('partials.hospital.bed_Details')
        </div>
    </div>
</div>
@endsection
@section('script')
    <script>
        console.log("{{$id}}")
        $(document).ready(function () {
            let table = $('#details').editableTableWidget();
            table.find('td').on('click keypress dblclick', function(evt, newValue) {
                if(!$(this).hasClass('values')) return false;
            });
            table.find('td').on('validate', function(evt, newValue) {
                if (isNaN(newValue)) {
                    return false; // mark cell as invalid
                }
            });
            table.find('td').on('change',async function (e, newValue) {
                let type = $(this).attr('id');
                let url = "/hospital/bed/dashboard/{{$id}}/{{$dept}}"
                try{
                    await axios.post(url,{
                        'newValue' : newValue,
                        'type' : type
                    });
                }catch (e) {
                    console.log(e.response)
                }
                location.reload();
            })
        });
    </script>
@endsection
<style>

</style>
