@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">{{ __('Register') }}</div>
                    <div class="card-body">
                        @if(session()->has('error'))
                            <div class="alert alert-danger" role="alert">
                                {{session()->pull('error')}}
                            </div>
                        @endif
                        <form method="POST" action="{{ route('register.hospital') }}">
                            @csrf
                            <div class="form-group row">
                                <label for="name" class="col-md-4 col-form-label text-md-right">{{ __('Name') }}</label>

                                <div class="col-md-6">
                                    <input id="name" placeholder="Hospital Name" type="text" class="form-control @error('name') is-invalid @enderror" name="name" value="{{ old('name') }}" required autocomplete="name" autofocus>

                                    @error('name')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="email" class="col-md-4 col-form-label text-md-right">{{ __('E-Mail Address') }}</label>

                                <div class="col-md-6">
                                    <input id="email" placeholder="Email" type="email" class="form-control @error('email') is-invalid @enderror" name="email" value="{{ old('email') }}" required autocomplete="email">

                                    @error('email')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>
                            </div>

                            <div class="form-group row">
                                <label for="password" class="col-md-4 col-form-label text-md-right">{{ __('Password') }}</label>

                                <div class="col-md-6">
                                    <input id="password" placeholder="Password" type="password" class="form-control @error('password') is-invalid @enderror" name="password" required autocomplete="new-password">

                                    @error('password')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="address" class="col-md-4 col-form-label text-md-right">{{ __('Address') }}</label>
                                <div class="col-md-6 d-flex justify-content-between">
                                    <div class="col-md-6" style="padding: 1px!important;">
                                        <input id="address" placeholder="Local Address" type="text" class="form-control @error('address') is-invalid @enderror" name="address" value="{{ old('address') }}" required autocomplete="address" autofocus>

                                        @error('address')
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $message }}</strong>
                                        </span>
                                        @enderror
                                    </div>
                                    <div class="col-md-6" style="padding: 1px!important;">
                                        <input id="pincode" type="number" maxlength="6" placeholder="Pincode" class="form-control @error('pincode') is-invalid @enderror" name="pincode" value="{{ old('pincode') }}" required autocomplete="pincode" autofocus>

                                        @error('pincode')
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $message }}</strong>
                                        </span>
                                        @enderror
                                    </div>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="city" class="col-md-4 col-form-label text-md-right">{{ __('Geo Location') }}</label>

                                <div class="col-md-6 d-flex justify-content-between">
                                    <div class="col-md-6" style="padding: 1px!important;">
                                        <input id="longitude" placeholder="Longitude" type="text" class="form-control @error('longitude') is-invalid @enderror" name="longitude" value="{{ old('longitude') }}" required autocomplete="longitude" autofocus>
                                    </div>
                                    @error('longitude')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                    <div class="col-md-6" style="padding: 1px!important;">
                                        <input id="latitude" type="text" placeholder="Latitude" class="form-control @error('latitude') is-invalid @enderror" name="latitude" value="{{ old('latitude') }}" required autocomplete="latitude" autofocus>
                                    </div>
                                    @error('latitude')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>
                                <div class="col-md-2 location-detect">
                                    <button id="location" type="button" class="badge badge-info">Detect</button>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="phone" class="col-md-4 col-form-label text-md-right">{{ __('Phone') }}</label>

                                <div class="col-md-6">
                                    <input id="phone" placeholder="Phone" type="number" maxlength="10" class="form-control @error('phone') is-invalid @enderror" name="phone" value="{{ old('phone') }}" required autocomplete="phone" autofocus>

                                    @error('phone')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                    @enderror
                                </div>
                            </div>
                            <div class="form-group row mb-0">
                                <div class="col-md-6 offset-md-4 text-center">
                                    <button type="submit" class="btn btn-primary">
                                        {{ __('Register') }}
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
@section('script')
    <script src="{{asset('js/google_maps.js')}}"></script>
    <script>
        $('#location').click(function (e) {
            e.preventDefault();
            console.log('clicked');
            if( navigator.geolocation )
            {
                navigator.geolocation.getCurrentPosition( function (position) {
                    $('#longitude').val(position.coords.longitude);
                    $('#latitude').val(position.coords.latitude);
                }, function () {
                    alert('error getting location')
                } );
            }
            else
            {
                alert("Sorry, your browser does not support geolocation services.");
            }
        })
    </script>
@endsection
@section('style')
    <style>
        .card{
            /*background-color: lightblue!important;*/
{{--            background-image: url({{asset('images/reg_bg.jpg')}});--}}
            background-size: 100% 100%;
            border: 2px solid black;
        }
        /*.card-header{*/
        /*    border-bottom: 2px solid black!important;*/
        /*    font-weight: bold;*/
        /*    text-shadow: 2px 2px white;*/
        /*    text-align: center;*/
        /*}*/
        /*.card-body{*/
        /*    font-weight: bold;*/
        /*    text-shadow: 2px 1px navajowhite;*/
        /*}*/
        .location-detect{
            right: 28px;
            bottom: -7px;
        }
    </style>
@endsection
