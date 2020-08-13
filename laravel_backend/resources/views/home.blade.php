@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">{{auth()->user()->name}} Dashboard</div>
                <div class="card-body">
                    <div class="beds link">
                        <a href="{{url('/hospital/bed/dashboard/'.auth()->user()->details()->id)}}">Hospital Beds</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

<style>
    .card{
        background-size: 100% 100%;
        border: 2px solid black;
    }
    .card-header{
        border-bottom: 2px solid black!important;
        font-weight: bold;
        text-shadow: 2px 2px white;
        text-align: center;
    }
    .card-body{
        font-weight: bold;
        text-shadow: 2px 1px navajowhite;
    }
    .beds{
        background-image: url({{asset('images/beds.jpg')}});
        background-size: 100% 100%;
    }
    .link{
        height: 80px;
        text-align: center;
        font-size: 50px;
        margin-bottom: 10px;
    }
</style>
