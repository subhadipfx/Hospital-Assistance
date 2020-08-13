@extends('layouts.app')
@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header text-uppercase">Hospital Management <span class="badge badge-info">Quick View</span></div>
                    <div class="card-body">
                        <div class="float-right mb-3">
                            <a class="btn btn-outline-info" href="{{route('register.hospital')}}">Add a new Hospital</a>
                        </div>
                        @if(session('error'))
                            <div class="alert alert-danger text-center" role="alert">
                                {{session()->pull('error')}}
                            </div>
                        @endif
                        @include('partials.hospital.list')
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
@section('script')
    <script>

    </script>
@endsection
<style>
    .alert{
        width: 80%!important;
    }
</style>
