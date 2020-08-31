# frozen_string_literal: true

class GroupsController < ApplicationController
  respond_to :json, only: %i[index create]
  respond_to :html, only: %i[new]

  # TO-DO: Consider reworking frontend to paginate this once the response
  # size grows too large
  def index
    groups = Group.includes(:info, :location).approved.limit(params[:limit])
    render json: groups
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)

    if group.save
      render json: { status: :success, group: GroupSerializer.new(group) }
    else
      render json: { status: :error, errors: group.errors }, status: :bad_request
    end
  end

  def show
    @group = Group.find_by!({ slug: params[:slug] })
    @map_config = MapConfig.for_params(params) if embeded_view?

    respond_to do |format|
      format.html { render template: 'map/index', assigns: { group: GroupSerializer.new(@group) } }
      format.json { render json: group }
    end
  end

  def edit; end

  def update
    group = Group.find_by!({ slug: params[:slug] })

    if group.update(group_params)
      render json: { status: :success, group: GroupSerializer.new(group) }
    else
      render json: { status: :error, errors: group.errors }, status: :bad_request
    end
  end

  def destroy; end

  private

  def group_params
    params.require(:group).permit(
      :type,
      :name,
      info_attributes: %i[
        link
        members
        is_regional
      ],
      location_attributes: %i[
        lat
        lon
      ],
      submitter_attributes: %i[
        email
      ]
    )
  end
end
