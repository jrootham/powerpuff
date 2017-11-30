class SearchController < ActionController::API
  def index
    empty_pathway = Hash[Pathway::LEVELS.map{ |level| [level, []] }].with_indifferent_access
    context = GeneratePathway.call(query_params: parsed_query_params.with_indifferent_access,
                                   pathway: empty_pathway)
    if context.success?
      render json: context.pathway
    else
      render json: context.message
    end
  end

  def maesd_programs
    render json: MaesdProgram.all.to_a
  end

  def search_params
    params.permit(:hs_courses, :noc_codes, :ouac_codes, :salary)
  end

  def parsed_query_params
    {}.tap do |parsed_query|
      Pathway::PERMITTED_QUERY_PARAMS.each do |pp|
        parsed_query[pp.to_sym] = send("parse_#{pp}", search_params[pp]) if search_params[pp].present?
      end
    end
  end

  def parse_hs_courses(value)
    value.split(',')
  end

  def parse_noc_codes(value)
    value.split(',')
  end

  def parse_cip_codes(value)
    value.split(',')
  end

  def parse_salary(value)
    value.to_i
  end

  def parse_ouac_codes(value)
    value.split(',')
  end
end