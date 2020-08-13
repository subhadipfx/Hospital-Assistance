@extends('layouts.app')
@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header text-uppercase">User Management</div>
                    <div class="card-body">
                        <div>
                            @if(session()->has('msg'))
                                <div class="alert {{session()->pull('type')}} text-center" role="alert">
                                    {{session()->pull('msg')}}
                                </div>
                            @endif
                            <div class="row">
                                <div class="col-2">
                                    <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                                        <a class="nav-link active" id="v-pills-profile-tab" data-toggle="pill" href="#v-pills-add" role="tab" aria-controls="v-pills-add" aria-selected="false" >ADD</a>
                                        <a class="nav-link" id="v-pills-home-tab" data-toggle="pill" href="#v-pills-list" role="tab" aria-controls="v-pills-list" aria-selected="true">List</a>
                                    </div>
                                </div>
                                <div class="col-10">
                                    <div class="tab-content" id="v-pills-tabContent">
                                        <div class="tab-pane fade show active" id="v-pills-add" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                                            @include('partials.admin.add')
                                        </div>
                                        <div class="tab-pane fade" id="v-pills-list" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                            @include('partials.admin.list')
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
</style>
